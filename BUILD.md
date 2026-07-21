# Building without the original solution

The original `.sln`/`.vbproj` weren't available, so a minimal, reconstructed
`admintickets.vbproj` (+ `admintickets.sln`) is included here. It compiles every
`.vb` file into **`bin\admintickets.dll`** — the only build artifact the app
needs. The `.aspx`/`.ascx` markup, `Web.config` and static assets are **not**
built; IIS compiles markup at runtime, so you just copy those to the server.

> Only rebuild is needed because the server-side poller lives in `.vb` code
> (`ChatHubticketco.vb`, `Global.asax.vb`). Pure markup/config edits deploy as-is.

---

## Option 1 (recommended): MSBuild via `build.bat`

Needs MSBuild, which comes free with **Build Tools for Visual Studio**
(installer → *".NET desktop build tools"* workload). No full VS or IDE required.

```cmd
build.bat
```

`build.bat` locates MSBuild (via `vswhere`, falling back to the framework
MSBuild) and runs:

```cmd
msbuild admintickets.vbproj /p:Configuration=Release /p:Platform=AnyCPU
```

Result: `bin\admintickets.dll` (rebuilt). You can also just double-click
`admintickets.sln` to open it in Visual Studio if you have it.

## Option 2 (zero install): compile with the in-repo Roslyn `vbc.exe`

The repo already ships a VB compiler at `bin\roslyn\vbc.exe`, so you can rebuild
with nothing installed. From the repo root:

```cmd
bin\roslyn\vbc.exe /noconfig /target:library /out:bin\admintickets.dll ^
  /rootnamespace:admintickets /define:"_MYTYPE=\"Web\"" /optioninfer+ /langversion:14 ^
  /imports:Microsoft.VisualBasic,System,System.Collections,System.Collections.Generic,System.Data,System.Diagnostics,System.Linq,System.Xml.Linq,System.Web ^
  /libpath:"%WINDIR%\Microsoft.NET\Framework64\v4.0.30319";bin ^
  /r:System.dll /r:System.Core.dll /r:System.Data.dll /r:System.Xml.dll ^
  /r:System.Xml.Linq.dll /r:System.Configuration.dll /r:System.Web.dll ^
  /r:System.Web.Extensions.dll /r:System.Web.Services.dll /r:System.Net.Http.dll ^
  /r:WindowsBase.dll /r:MySql.Data.dll /r:Newtonsoft.Json.dll ^
  /r:Microsoft.AspNet.SignalR.Core.dll /r:Microsoft.AspNet.SignalR.SystemWeb.dll ^
  /r:Microsoft.Owin.dll /r:Microsoft.Owin.Host.SystemWeb.dll ^
  /r:Microsoft.Owin.Security.dll /r:Owin.dll /r:Microsoft.Web.Infrastructure.dll ^
  /r:DocumentFormat.OpenXml.dll ^
  *.vb
```

(`/libpath` includes the framework folder so the bare framework `.dll`
references resolve; the `bin` folder resolves the third-party ones.)

---

## If the build complains about `System.Windows`

Four **unused** legacy hub files — `ChatHub.vb`, `ChatHubnew.vb`,
`ChatHubrestricted.vb`, `ChatHubnewrestricted.vb` — carry a stray
`Imports System.Windows` (WPF). The project already references `WindowsBase.dll`
to satisfy it. If you'd rather drop the WPF reference entirely, delete that one
`Imports System.Windows` line from each of those four files (nothing uses it),
then remove `WindowsBase` from the references.

## After a successful build — deploy

Copy to the server (see `deploy-manifest.md` for the full list):

1. `bin\admintickets.dll`  ← the rebuilt assembly
2. `dash_display.aspx`, `dash_control.aspx`  ← changed markup
3. `Web.config`  ← now contains the `Ticketco*` appSettings

Then set `TicketcoAutoStart` / `TicketcoActiveEventId` and recycle the app pool.

> Heads up: this reconstructed project lists all `.vb` as flat `<Compile>` items
> (no Solution-Explorer nesting of `.designer.vb` under their pages). That has no
> effect on the compiled output — it only looks flat in the VS tree. If your real
> `.sln`/`.vbproj` turns up later, prefer it and delete these reconstructed files.
