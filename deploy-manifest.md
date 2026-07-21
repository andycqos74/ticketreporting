# Deploy Manifest

Reduced to the live dashboard + TicketCo poller. After building
`bin\admintickets.dll` (see `BUILD.md`), copy these to the server.

## ✅ Ship

| Item | Notes |
|------|-------|
| `bin\` (all `*.dll`) | Rebuilt `admintickets.dll` + MySql.Data, Newtonsoft.Json, SignalR, Owin, Microsoft.Web.Infrastructure. |
| `bin\roslyn\` | **Required** — `Web.config` `<system.codedom>` uses it to compile `.aspx` at runtime. |
| `dash_display.aspx`, `dash_control.aspx` | The two pages. |
| `Global.asax` | Markup (its `.vb` is in the DLL). |
| `Web.config` | With the rotated `TicketcoApiToken` + DB connection string. |
| `Scripts\` | jquery, jquery-ui, signalR client. |
| `css\jquery-ui.min.css`, `images\ground6.png` | Assets the dashboard references (Bootstrap is loaded from CDN). |

## ❌ Don't ship (source/dev only)

`*.vb`, `*.designer.vb`, `packages.config`, `*.sln`, `*.vbproj`, `build.bat`,
`*.md`, `.gitignore`. Optional: `bin\*.pdb`, `bin\*.xml`.

## Keep the poller alive on IIS

App pool → **Start Mode = AlwaysRunning**, **Idle Time-out = 0**; site →
**Preload Enabled = True**. With `TicketcoAutoStart=true` the poller re-arms
after every recycle.

## Example publish + copy

```cmd
robocopy . \\SERVER\wwwroot\admintickets dash_display.aspx dash_control.aspx Global.asax Web.config
robocopy bin \\SERVER\wwwroot\admintickets\bin /MIR /XF *.pdb *.xml
robocopy Scripts \\SERVER\wwwroot\admintickets\Scripts /MIR
robocopy css \\SERVER\wwwroot\admintickets\css jquery-ui.min.css
robocopy images \\SERVER\wwwroot\admintickets\images ground6.png
```
