# ticketreporting

Live match-day ticket dashboard, TicketCo poller and ticket printing, split out of the legacy
admintickets site (the full legacy site is in `C:\2026source code\TMS`). See `BUILD.md`,
`DEPLOYMENT.md`, `REVIEW.md` and `deploy-manifest.md`.

## Stack
- VB.NET ASP.NET WebForms, .NET Framework 4.8, IIS (markup compiled by IIS at runtime)
- SignalR 2 via OWIN; MySQL (MySql.Data); Newtonsoft.Json
- `ChatHubticketco.vb` — SignalR hub + `TicketcoImporter` + `TicketcoPoller` (started in `Global.asax.vb`)
- Pages: `dash_display.aspx` (screen), `dash_control.aspx` (control), `2026print-tickets.aspx`

## Build
```cmd
build.bat
```
Output is `bin\admintickets.dll` — the only build artifact, and it is committed. If MSBuild
isn't available, `BUILD.md` has the direct `bin\roslyn\vbc.exe` command line.
Only the `.vb` files listed in `admintickets.vbproj` are compiled; rebuild after changing them.

## Config and secrets
- `Web.config` is committed but holds **no secrets**. It pulls them from two gitignored files
  next to it, created from the committed templates:
  - `secrets.config` (from `secrets.config.example`) — `TicketcoApiToken`
  - `connectionStrings.config` (from `connectionStrings.config.example`) — `QosTickets`
- Code reads them via `ConfigurationManager.AppSettings(...)` / `.ConnectionStrings(...)`.
  Never hardcode a token, password or connection string in `.vb`, `.aspx` or docs.
- This repo is **public**. Old credentials are in git history and must be treated as leaked.

## Deploy
- `tools/Deploy-ToIIS.ps1` (see `DEPLOYMENT.md`) clones/updates the repo on the server, mirrors
  the deploy set to IIS, and seeds the two secret files from the templates only if missing.
- DB changes: `migration*.sql`.

## Project rules
- Keep it VB.NET/WebForms; no framework upgrades unless asked.
- `report-output/` and `tc-cache/` are runtime output, not source.
