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
- **URL Rewrite Module 2.0** — `Web.config` has an HTTP→HTTPS redirect rule
  under `<system.webServer><rewrite>`, which needs this module installed. It's
  a separate download, not a Windows Feature:
  <https://www.iis.net/downloads/microsoft/url-rewrite>. If it's missing, IIS
  will throw a config error on any request to the site (not just skip the
  rule), so install it before creating the site.
- **Git for Windows** — for cloning/pulling the repo.
- An SSL certificate for the new site's hostname, if you want HTTPS
  provisioned by the script. Otherwise bind one manually afterwards in IIS
  Manager.

Since another site is already on this server, the new site needs to
coexist on shared IPs. The script binds by **hostname** (SNI / host header)
rather than claiming a whole IP:port, so it doesn't collide with the
existing site's bindings — you just need a DNS name for this app (e.g.
`tickets.yourdomain.com`) pointed at the server.

## One-line deploy

```powershell
.\tools\Deploy-ToIIS.ps1 -HostName tickets.yourdomain.com -CertificateThumbprint <thumbprint>
```

Omit `-CertificateThumbprint` to get an HTTP-only binding, then attach a
certificate to the HTTPS binding yourself in IIS Manager afterwards (the
script still creates the HTTPS binding shell so it stays SNI-scoped to this
host name — see the script for details).

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
4. Copies the deploy set — `bin\`, `dash_display.aspx`, `dash_control.aspx`,
   `Global.asax`, `Web.config`, `Scripts\`, `css\jquery-ui.min.css`,
   `images\ground6.png` — into `C:\inetpub\wwwroot\admintickets` via
   `robocopy /MIR`, matching `deploy-manifest.md`. Source files (`.vb`,
   `.sln`, `.vbproj`, `*.sql`, this doc, etc.) never reach the web root.
5. If `secrets.config` / `connectionStrings.config` don't already exist in
   the site folder, seeds them from the `.example` templates (with
   placeholder values) so the app doesn't fail to start with a missing-file
   config error. **Warns you to fill in the real values** — see the next
   section. Existing `secrets.config` / `connectionStrings.config` on the
   server are never touched by the script (they're gitignored, so they
   don't exist in the git checkout to overwrite them with).
6. Creates the `admintickets` app pool if it doesn't exist, with
   `managedRuntimeVersion=v4.0`, `startMode=AlwaysRunning`,
   `idleTimeout=0` — the app runs a server-side polling timer
   (`TicketcoPoller`) that stops if the pool idles out or recycles without
   preload.
7. Creates the `admintickets` site if it doesn't exist, bound to the given
   `-HostName` on HTTP (80) and HTTPS (443, SNI), with **Preload Enabled**.
8. Recycles the app pool so a redeploy picks up the new `bin\admintickets.dll`
   immediately.

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

- Browse to the site over HTTPS — `dash_display.aspx` should connect via
  SignalR and paint on load.
- If `TicketcoAutoStart=false` in `Web.config`, open `dash_control.aspx` and
  press **Start**.
- Confirm the app pool's `w3wp.exe` process stays alive between polls
  (doesn't disappear when idle) — that's the AlwaysRunning/Preload/idle
  timeout settings doing their job.

## Future deploys

Re-run `tools\Deploy-ToIIS.ps1`. If only `.vb` source changed, rebuild first
(`build.bat`, needs MSBuild / VS Build Tools) so `bin\admintickets.dll` is
current before the script copies it — the script does not compile anything
itself.
