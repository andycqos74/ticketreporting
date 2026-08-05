# Building

This repo has been reduced to the **live dashboard + TicketCo poller** only.
The build compiles seven `.vb` files into **`bin\admintickets.dll`** — the only
build artifact. The `.aspx` markup, `Web.config` and static assets deploy as-is
(IIS compiles markup at runtime).

Source compiled (see `admintickets.vbproj`):

- `ChatHubticketco.vb` — SignalR hub + `TicketcoImporter` + `TicketcoPoller`
- `Global.asax.vb` — starts the poller on app start
- `Startup.vb` — OWIN SignalR wiring
- `dash_display.aspx(.designer).vb`, `dash_control.aspx(.designer).vb`

## Build

```cmd
build.bat
```

`build.bat` locates MSBuild (via `vswhere`, else the framework MSBuild) and runs
`msbuild admintickets.vbproj /p:Configuration=Release`. You can also open
`admintickets.sln` in Visual Studio and press **Build**. Output:
`bin\admintickets.dll`.

No MSBuild installed? The repo ships `bin\roslyn\vbc.exe`; compile directly:

```cmd
bin\roslyn\vbc.exe /noconfig /target:library /out:bin\admintickets.dll ^
  /rootnamespace:admintickets /define:"_MYTYPE=\"Web\"" /optioninfer+ /langversion:14 ^
  /imports:Microsoft.VisualBasic,System,System.Collections,System.Collections.Generic,System.Data,System.Diagnostics,System.Linq,System.Web,System.Web.UI,System.Web.UI.HtmlControls,System.Web.UI.WebControls ^
  /libpath:"%WINDIR%\Microsoft.NET\Framework64\v4.0.30319";bin ^
  /r:System.dll /r:System.Core.dll /r:System.Data.dll /r:System.Configuration.dll /r:System.Web.dll ^
  /r:MySql.Data.dll /r:Newtonsoft.Json.dll /r:Microsoft.AspNet.SignalR.Core.dll ^
  /r:Microsoft.AspNet.SignalR.SystemWeb.dll /r:Microsoft.Owin.dll ^
  /r:Microsoft.Owin.Host.SystemWeb.dll /r:Owin.dll /r:Microsoft.Web.Infrastructure.dll ^
  ChatHubticketco.vb Global.asax.vb Startup.vb ^
  dash_control.aspx.designer.vb dash_control.aspx.vb ^
  dash_display.aspx.designer.vb dash_display.aspx.vb
```

## After building — deploy

Copy to the server (full list in `deploy-manifest.md`): `bin\admintickets.dll`,
the two `.aspx` files, `Web.config`, and the `Scripts\ css\ images\` assets.
Set the `Ticketco*` keys in `Web.config` and recycle the app pool.

## Adding a server control later

If you add a control to a dashboard page, add a matching field to that page's
`.designer.vb` (or, in Visual Studio, right-click the `.aspx` → **Convert to
Web Application**).
