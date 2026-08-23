# Deploying to a Windows Server (IIS)

This assumes the target server **already has IIS installed and running, with
at least one other site already hosted on it**. The steps and the script
below are additive only — they create a new app pool and a new site
alongside what's already there; nothing about the existing site or the
server-wide IIS config is touched.

The fast path is `tools\Deploy-ToIIS.ps1` (see below). This document also
covers the manual steps it automates, and the two things the script can't do
for you: pointing the DB connection through WireGuard, and rotating secrets.

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
5. Creates the `admintickets` app pool if it doesn't exist, with
   `managedRuntimeVersion=v4.0`, `startMode=AlwaysRunning`,
   `idleTimeout=0` — the app runs a server-side polling timer
   (`TicketcoPoller`) that stops if the pool idles out or recycles without
   preload.
6. Creates the `admintickets` site if it doesn't exist, bound to the given
   `-HostName` on HTTP (80) and HTTPS (443, SNI), with **Preload Enabled**.
7. Recycles the app pool so a redeploy picks up the new `bin\admintickets.dll`
   immediately.

It does **not** touch `Web.config`'s connection string or app secrets — do
that once, manually, per the next section (re-deploys via the script
preserve your edits, since `Web.config` in the deployed site folder is not
overwritten by source... actually it **is** overwritten by the robocopy step,
since the file ships from the repo. See the note below.)

> **Note on `Web.config` edits surviving redeploys:** the script robocopies
> `Web.config` from the git checkout into the site every run, so any edits
> you make directly in `C:\inetpub\wwwroot\admintickets\Web.config` (the
> connection string, rotated secrets) will be **overwritten on the next
> redeploy**. Either commit the production connection string/secrets to a
> branch you deploy from, or keep a `Web.config` edit step as part of your
> deploy runbook and reapply it after each `Deploy-ToIIS.ps1` run. The
> repo's own `Web.config` comments suggest the longer-term fix: move secrets
> into an uncommitted `secrets.config` referenced via `<appSettings
> file="secrets.config">`, which the deploy script's robocopy would then
> leave alone.

## Point the DB connection through WireGuard

Once the WireGuard tunnel to the DB host is up, edit the connection string
in the deployed `Web.config`:

```
C:\inetpub\wwwroot\admintickets\Web.config
```

```xml
<connectionStrings>
  <add name="QosTickets" connectionString="Data Source=<wireguard-tunnel-ip>;port=3306;Initial Catalog=qosfctickets;User Id=qosfclivedb;password=<new-password>" />
</connectionStrings>
```

Then recycle the app pool (`Restart-WebAppPool admintickets`) to pick it up.

## Rotate secrets while you're moving servers

`REVIEW.md` already flags these as live secrets sitting in git history — a
server move is a convenient, low-disruption time to rotate them, since
you're editing `Web.config` for the DB host change anyway:

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
