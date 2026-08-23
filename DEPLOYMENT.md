# Deploying to a Windows Server (IIS)

This assumes the target server **already has IIS installed and running, with
at least one other site already hosted on it**. The steps and the script
below are additive only — they create a new app pool and a new site
alongside what's already there; nothing about the existing site or the
server-wide IIS config is touched.

The fast path is `tools\Deploy-ToIIS.ps1` (see below). This document also
covers the manual steps it automates, and the one thing the script can't do
for you: filling in the real secrets on first deploy (`secrets.config` /
`connectionStrings.config`, including pointing the DB connection through
WireGuard).

## Prerequisites

Check these once per server (the script checks/installs the Windows Features
but not the URL Rewrite Module, which isn't a Windows Feature):

- **ASP.NET 4.8** — `Get-WindowsFeature Web-Asp-Net45` should show Installed.
  If not, `Install-WindowsFeature Web-Asp-Net45` (safe to run alongside an
  existing site — it only adds the ASP.NET 4.x module to IIS).
- **WebSockets** — `Get-WindowsFeature Web-WebSockets` (needed for SignalR).
- **URL Rewrite Module 2.0** — `Web.config` has a `<system.webServer><rewrite>`
  section (the HTTP→HTTPS redirect rule is disabled — see "Access via
  Cloudflare Tunnel" below — but the section itself is still present). IIS
  needs this module installed just to parse that section, disabled rule or
  not. It's a separate download, not a Windows Feature:
  <https://www.iis.net/downloads/microsoft/url-rewrite>. If it's missing, IIS
  will throw a config error on any request to the site, so install it before
  creating the site.
- **Git for Windows** — for cloning/pulling the repo.
- **No SSL certificate needed on IIS itself** if you're accessing through a
  Cloudflare Tunnel (the common case — see below): Cloudflare terminates TLS
  at its edge and `cloudflared` forwards to IIS over plain HTTP, so the site
  only needs an HTTP binding. Only get a certificate for IIS if it will serve
  HTTPS directly to the internet with no tunnel/proxy in front.

Since another site is already on this server, the new site needs to
coexist on shared IPs. The script binds by **hostname** (SNI / host header)
rather than claiming a whole IP:port, so it doesn't collide with the
existing site's bindings — you just need a hostname for this app (e.g.
`tickets.yourdomain.com`).

## Access via Cloudflare Tunnel

This is the expected setup: no inbound firewall rule or public IP binding is
needed for this site at all. `cloudflared` on the server makes an
**outbound-only** connection to Cloudflare; Cloudflare's edge handles the
public HTTPS listener and DNS, and proxies matching requests down the tunnel
to a local address you configure — here, IIS on plain HTTP.

Because of this, `Web.config`'s `HTTP to HTTPS Redirect` rewrite rule is
**disabled** in this repo. Traffic from `cloudflared` to IIS is always plain
HTTP internally, so the rule's `SERVER_PORT_SECURE` check is always `0` at
the origin — leaving it enabled would redirect every request forever
(redirect → back through the tunnel → still HTTP internally → redirect
again). Cloudflare's edge already enforces HTTPS publicly (Always Use
HTTPS), so this is not a gap, just moved up a layer.

Set up the tunnel once IIS is deployed and serving HTTP locally:

```powershell
winget install --id Cloudflare.cloudflared -e
cloudflared tunnel login
cloudflared tunnel create admintickets
cloudflared tunnel route dns admintickets tickets.yourdomain.com
```

Create `C:\Windows\System32\config\systemprofile\.cloudflared\config.yml`
(the path `cloudflared service install` will look for once installed as a
service — or pass `--config` explicitly):

```yaml
tunnel: <tunnel-id-from-tunnel-create>
credentials-file: C:\path\to\<tunnel-id>.json

ingress:
  - hostname: tickets.yourdomain.com
    service: http://localhost:80
  - service: http_status:404
```

Then install and start it as a Windows service so it survives reboots:

```powershell
cloudflared service install
Start-Service Cloudflared
```

`tickets.yourdomain.com` must match the `-HostName` you deploy the IIS site
with (the script's host-header binding on port 80) — that's how IIS knows
which site to route the incoming request to once `cloudflared` hands it off
locally.

## One-line deploy

```powershell
.\tools\Deploy-ToIIS.ps1 -HostName tickets.yourdomain.com
```

This creates an HTTP-only site on port 80 — correct for the Cloudflare
Tunnel setup above. If IIS instead needs to serve HTTPS directly to the
internet (no tunnel/proxy in front), get a certificate and add
`-CertificateThumbprint <thumbprint>`.

Run it again any time to redeploy (`git pull` + re-sync files + recycle the
app pool) — it's idempotent, and won't recreate the app pool or site if they
already exist.

See `.\tools\Deploy-ToIIS.ps1 -?` for the full parameter list (paths, site
name, app pool name, ports, branch, etc.) — defaults match what's described
here.

## What the script does

1. Confirms it's running elevated.
2. Installs `Web-Asp-Net45` / `Web-WebSockets` if missing (no-op if already
   present; doesn't touch other features or other sites).
3. Clones the repo to `C:\src\ticketreporting` (or pulls if it already
   exists there).
4. **Rebuilds `bin\admintickets.dll` from source**, using `bin\roslyn\vbc.exe`
   (no MSBuild/Visual Studio install needed). The DLL is also committed to
   git for convenience, but a committed DLL can silently drift out of sync
   with the `.vb` source if someone forgets to rebuild before committing —
   that already happened once in this repo and broke the SignalR hub's
   client-side proxy (`chat.server.xyz is not a function`) in a way that
   looked like a config/deploy problem rather than a stale-binary problem.
   Rebuilding on every deploy makes that impossible. Skip with `-SkipBuild`
   only if you've built and verified the DLL yourself.
5. Copies the deploy set — `bin\`, `dash_display.aspx`, `dash_control.aspx`,
   `2026print-tickets.aspx`, `Global.asax`, `Web.config`, `Scripts\`,
   `css\` (jquery-ui/Font Awesome/Bootstrap-custom styles), `webfonts\`
   (Font Awesome, needed by the ticket-printing page), `images\ground6.png`
   — into `C:\inetpub\wwwroot\admintickets`, matching `deploy-manifest.md`.
   Source files (`.vb`, `.sln`, `.vbproj`, `*.sql`, this doc, etc.) never
   reach the web root.
6. If `secrets.config` / `connectionStrings.config` don't already exist in
   the site folder, seeds them from the `.example` templates (with
   placeholder values) so the app doesn't fail to start with a missing-file
   config error. **Warns you to fill in the real values** — see the next
   section. Existing `secrets.config` / `connectionStrings.config` on the
   server are never touched by the script (they're gitignored, so they
   don't exist in the git checkout to overwrite them with).
7. Creates the `admintickets` app pool if it doesn't exist, with
   `managedRuntimeVersion=v4.0`, `startMode=AlwaysRunning`,
   `idleTimeout=0` — the app runs a server-side polling timer
   (`TicketcoPoller`) that stops if the pool idles out or recycles without
   preload.
8. Creates the `admintickets` site if it doesn't exist, bound to the given
   `-HostName` on HTTP (80), with **Preload Enabled**. Adds an HTTPS (443,
   SNI) binding too, only if `-CertificateThumbprint` was given.
9. Recycles the app pool so the newly rebuilt `bin\admintickets.dll` takes
   effect.

`Web.config` itself carries no secrets any more — it points at
`secrets.config` (`<appSettings file="secrets.config">`) and
`connectionStrings.config` (`<connectionStrings
configSource="connectionStrings.config">`), both of which are gitignored and
live only on the server. That means redeploying (`git pull` + resync +
recycle) is now safe to run at any time without clobbering the DB connection
string or the API token — only step 5, above, ever touches those files, and
only when they're missing.

## Fill in the real secrets (first deploy only)

On the very first deploy, edit the two files the script seeded from
`*.example` templates:

```
C:\inetpub\wwwroot\admintickets\secrets.config
C:\inetpub\wwwroot\admintickets\connectionStrings.config
```

**`secrets.config`** — the (rotated) TicketCo API token:

```xml
<appSettings>
  <add key="TicketcoApiToken" value="<real-token>" />
</appSettings>
```

**`connectionStrings.config`** — the DB connection, pointed at the
WireGuard tunnel IP once that's up, with a rotated password:

```xml
<connectionStrings>
  <add name="QosTickets" connectionString="Data Source=<wireguard-tunnel-ip>;port=3306;Initial Catalog=qosfctickets;User Id=qosfclivedb;password=<new-password>" />
</connectionStrings>
```

Then recycle the app pool (`Restart-WebAppPool admintickets`) to pick both up.

`REVIEW.md` also flags cleartext app-login passwords that may still be
inline in `Web.config`'s `<credentials passwordFormat="Clear">` block (not
covered by this secrets split) — rotate those too while you're here.

## Rotate secrets while you're moving servers

The values that were in the old committed `Web.config` are still live in git
history — a server move is a convenient, low-disruption time to rotate them,
since you're filling in `secrets.config`/`connectionStrings.config` anyway:

- MySQL password for `qosfclivedb`
- `TicketcoApiToken` (TicketCo API token)
- Any cleartext app-login passwords still in `Web.config`

Rotating the values doesn't erase them from git history, but it does stop
the old ones being live credentials.

## Verify

- Browse to `https://tickets.yourdomain.com` (through the tunnel — Cloudflare
  serves the public HTTPS) — `dash_display.aspx` should connect via SignalR
  and paint on load. `http://localhost` on the server itself should also
  work directly (that's what `cloudflared` talks to).
- If `TicketcoAutoStart=false` in `Web.config`, open `dash_control.aspx` and
  press **Start**.
- Confirm the app pool's `w3wp.exe` process stays alive between polls
  (doesn't disappear when idle) — that's the AlwaysRunning/Preload/idle
  timeout settings doing their job.

## Future deploys

Just re-run `tools\Deploy-ToIIS.ps1` — it pulls the branch, rebuilds
`bin\admintickets.dll` from source itself (via `bin\roslyn\vbc.exe`), re-syncs
files, and recycles the app pool. No separate build step needed.
