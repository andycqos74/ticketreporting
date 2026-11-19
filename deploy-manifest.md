# Deploy Manifest

Reduced to the live dashboard + TicketCo poller. **Always rebuild
`bin\admintickets.dll`** (see `BUILD.md`) before copying to the server —
don't rely on the DLL as checked out of git. It's committed for convenience,
but nothing enforces it staying in sync with the `.vb` source; it has
already gone stale once and broken the SignalR hub's client-side proxy in a
way that looked like a config problem rather than a stale-binary one.
`tools\Deploy-ToIIS.ps1` rebuilds it automatically for you.

## ✅ Ship

| Item | Notes |
|------|-------|
| `bin\` (all `*.dll`) | Rebuilt `admintickets.dll` + MySql.Data, Newtonsoft.Json, SignalR, Owin, Microsoft.Web.Infrastructure. |
| `bin\roslyn\` | **Required** — `Web.config` `<system.codedom>` uses it to compile `.aspx` at runtime. |
| `dash_display.aspx`, `dash_control.aspx`, `2026print-tickets.aspx` | The three pages. |
| `UC_footer.ascx`, `UC_header.ascx` | Shared markup for the user controls (their `.vb` code-behind is in the DLL, but the `.ascx` markup itself deploys separately, same as `.aspx`). |
| `Global.asax` | Markup (its `.vb` is in the DLL). |
| `Web.config` | No secrets in it — points at `secrets.config` / `connectionStrings.config` (see below). |
| `Scripts\` | jquery, jquery-ui, signalR client. |
| `css\jquery-ui.min.css`, `css\all.min.css`, `css\bs4_custom.css` | Dashboard + ticket-printing styles (Bootstrap itself is loaded from CDN). |
| `webfonts\` | Font Awesome, referenced by `css\all.min.css` — needed by the ticket-printing page. |
| `images\ground6.png` | Dashboard background asset. |

## 🔐 Create on the server, never ship from git

`secrets.config` and `connectionStrings.config` hold the real
`TicketcoApiToken` and DB connection string. Both are gitignored — they
don't exist in the repo at all, so a `git clone`/`git pull` never touches
them once they're created on the server. First deploy: copy
`secrets.config.example` → `secrets.config` and
`connectionStrings.config.example` → `connectionStrings.config` next to
`Web.config` on the server, and fill in the real values (see
`DEPLOYMENT.md`). The app won't start without them, since `Web.config`
references both by name.

## ❌ Don't ship (source/dev only)

`*.vb`, `*.designer.vb`, `packages.config`, `*.sln`, `*.vbproj`, `build.bat`,
`*.md`, `.gitignore`, `*.example`. Optional: `bin\*.pdb`, `bin\*.xml`.

## Keep the poller alive on IIS

App pool → **Start Mode = AlwaysRunning**, **Idle Time-out = 0**; site →
**Preload Enabled = True**. With `TicketcoAutoStart=true` the poller re-arms
after every recycle.

## Example publish + copy

```cmd
robocopy . \\SERVER\wwwroot\admintickets dash_display.aspx dash_control.aspx 2026print-tickets.aspx UC_footer.ascx UC_header.ascx Global.asax Web.config
robocopy bin \\SERVER\wwwroot\admintickets\bin /MIR /XF *.pdb *.xml
robocopy Scripts \\SERVER\wwwroot\admintickets\Scripts /MIR
robocopy css \\SERVER\wwwroot\admintickets\css jquery-ui.min.css all.min.css bs4_custom.css
robocopy webfonts \\SERVER\wwwroot\admintickets\webfonts /MIR
robocopy images \\SERVER\wwwroot\admintickets\images ground6.png
```
