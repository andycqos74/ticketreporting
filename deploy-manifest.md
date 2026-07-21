# Deploy Manifest — what belongs on the server

This is an ASP.NET **Web Forms (Web Application Project)**. The `.vb` source is
compiled into `bin\admintickets.dll` at build time and is **not** deployed. Only
markup, config, the `bin` folder, and static assets go to the server.

Build first (see REVIEW.md §4), then copy the items below.

---

## ✅ Ship these to the server

| Item | Notes |
|------|-------|
| `bin\` (all `*.dll`) | Compiled app + MySql.Data, Newtonsoft.Json, SignalR, Owin, Microsoft.Web.Infrastructure, etc. |
| `bin\roslyn\` | **Required.** `Web.config` `<system.codedom>` uses it to compile `.aspx` markup at runtime. |
| `*.aspx` / `*.ascx` | Every page/control you actually serve, plus their `UC_*.ascx` user controls. |
| `Global.asax` | Markup only (its `.vb` is in the DLL). |
| `Web.config` | With the real (rotated) `TicketcoApiToken` and connection strings. |
| `Scripts\` | jQuery, jQuery-UI, SignalR client. |
| `css\` | Stylesheets. |
| `images\` | `ground*.png`, etc. used by the dashboard map. |
| `webfonts\` | Font Awesome files referenced by the CSS. |
| `Files\` | **Create empty, writable by the app pool.** `import-sales.aspx` saves uploads to `~/Files/`. Not in the repo. |

Optional: `bin\*.pdb` — only if you want line numbers in stack traces.

## ❌ Do NOT ship (dev/source only)

- All `*.vb` and `*.designer.vb` (compiled into the DLL)
- `packages.config`, any `*.sln` / `*.vbproj`
- `README.md`, `REVIEW.md`, `deploy-manifest.md`, `.gitignore`
- `bin\*.xml` (IntelliSense docs)

## 🗑️ Deleted as junk (were committed by mistake)

- `admintickets.dll` (repo root) and `css\admintickets.dll` — stray DLL copies; only `bin\admintickets.dll` is real
- `bin\newstandrestricted.aspx.vb` — source wrongly placed in `bin`
- `standrestricted .aspx.vb` (space in name) — duplicate of `standrestricted.aspx.vb`
- `import_JSON.php`, `import_JSON_ST.php` — PHP won't run under IIS; replaced by the server-side poller
- `JSONtest.aspx` (+ `.vb`) — dead test page that ran `Process.Start` on the server

## ⚠️ Verify before removing (unknown if still linked)

Seasonal/one-off pages (`2021all.aspx`, `2026print-tickets.aspx`) and the extra
hub sources (`ChatHub.vb`, `ChatHubnew.vb`, `ChatHubrestricted.vb`,
`ChatHubnewrestricted.vb`). Grep your navigation/links before deleting.

---

## Example: publish + copy

Produce a clean deploy folder with MSBuild (no source files included):

```cmd
msbuild admintickets.vbproj /p:Configuration=Release ^
  /p:DeployOnBuild=true /p:WebPublishMethod=FileSystem ^
  /p:publishUrl=C:\publish\admintickets
```

Then push to the server with robocopy (mirrors, so removed files get cleaned up):

```cmd
robocopy C:\publish\admintickets \\SERVER\wwwroot\admintickets /MIR ^
  /XD Files /XF *.pdb *.xml
```

`/XD Files` keeps the server's upload folder from being wiped; drop `/XF *.pdb`
if you want symbols on the server.
```
