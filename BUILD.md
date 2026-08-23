# Building

This repo has been reduced to the **live dashboard + TicketCo poller +
ticket-printing page** only. The build compiles the `.vb` files listed below
into **`bin\admintickets.dll`** — the only build artifact. The `.aspx`
markup, `Web.config` and static assets deploy as-is (IIS compiles markup at
runtime).

Source compiled (see `admintickets.vbproj`):

- `ChatHubticketco.vb` — SignalR hub + `TicketcoImporter` + `TicketcoPoller`
- `Global.asax.vb` — starts the poller on app start
- `Startup.vb` — OWIN SignalR wiring
- `UC_footer.ascx.vb`, `UC_header.ascx.vb` — shared header/footer controls
- `dash_display.aspx(.designer).vb`, `dash_control.aspx(.designer).vb`
- `2026print-tickets.aspx(.designer).vb` — ticket-printing page

## Build

```cmd
build.bat
```

`build.bat` locates MSBuild (via `vswhere`, else the framework MSBuild) and runs
`msbuild admintickets.vbproj /p:Configuration=Release`. You can also open
`admintickets.sln` in Visual Studio and press **Build**. Output:
`bin\admintickets.dll`.

No MSBuild installed? The repo ships `bin\roslyn\vbc.exe`. **Prefer
`tools\Deploy-ToIIS.ps1`** for this (or read its `Build-Dll` function) —
it resolves `System.Web.Extensions.dll`/`System.Web.Services.dll` from the
GAC automatically, which the plain command below can't do. Those two
assemblies (needed by `2026print-tickets.aspx.vb` for `ScriptManager` and
`WebMethod`) typically exist only in the GAC on Windows Server, not as loose
files in `Framework64\v4.0.30319` alongside `System.Web.dll` etc., so a bare
`/r:System.Web.Extensions.dll` + `/libpath` will fail with `error BC30002:
Type ... is not defined` even though the reference name is correct — vbc.exe
doesn't search the GAC the way MSBuild does. Find the real paths first:

```powershell
$extPath = [System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions").Location
$svcPath = [System.Reflection.Assembly]::LoadWithPartialName("System.Web.Services").Location
```

Then compile, using those resolved paths for the two GAC-only references:

```cmd
bin\roslyn\vbc.exe /noconfig /target:library /out:bin\admintickets.dll ^
  /rootnamespace:admintickets /define:"_MYTYPE=\"Web\"" /optioninfer+ /langversion:14 ^
  /imports:Microsoft.VisualBasic,System,System.Collections,System.Collections.Generic,System.Data,System.Diagnostics,System.Linq,System.Web,System.Web.UI,System.Web.UI.HtmlControls,System.Web.UI.WebControls ^
  /libpath:"%WINDIR%\Microsoft.NET\Framework64\v4.0.30319";bin ^
  /r:System.dll /r:System.Core.dll /r:System.Data.dll /r:System.Xml.dll /r:System.Configuration.dll /r:System.Web.dll ^
  /r:%extPath% /r:%svcPath% ^
  /r:MySql.Data.dll /r:Newtonsoft.Json.dll /r:Microsoft.AspNet.SignalR.Core.dll ^
  /r:Microsoft.AspNet.SignalR.SystemWeb.dll /r:Microsoft.Owin.dll ^
  /r:Microsoft.Owin.Host.SystemWeb.dll /r:Owin.dll /r:Microsoft.Web.Infrastructure.dll ^
  ChatHubticketco.vb Global.asax.vb Startup.vb ^
  UC_footer.ascx.vb UC_header.ascx.vb ^
  dash_control.aspx.designer.vb dash_control.aspx.vb ^
  dash_display.aspx.designer.vb dash_display.aspx.vb ^
  2026print-tickets.aspx.designer.vb 2026print-tickets.aspx.vb
```

(`%extPath%`/`%svcPath%` as cmd env vars, set from the PowerShell snippet
above via `setx`/`set`, or just run the whole thing from PowerShell and
substitute `$extPath`/`$svcPath` directly — either way, `Deploy-ToIIS.ps1`
already does this for you and is the tested path.)

## After building — deploy

Copy to the server (full list in `deploy-manifest.md`): `bin\admintickets.dll`,
the three `.aspx` files, `Web.config`, and the `Scripts\`, `css\`,
`webfonts\`, `images\` assets. `Web.config` itself carries no secrets — on
first deploy, create
`secrets.config` and `connectionStrings.config` next to it on the server
(from the `.example` templates; see `DEPLOYMENT.md`) and fill in the real
`TicketcoApiToken` and DB connection string. Then recycle the app pool.

## Adding a server control later

If you add a control to a dashboard page, add a matching field to that page's
`.designer.vb` (or, in Visual Studio, right-click the `.aspx` → **Convert to
Web Application**).
