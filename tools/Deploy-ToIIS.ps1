<#
.SYNOPSIS
    Deploys/redeploys the ticket dashboard to IIS on a Windows Server that
    already has IIS running, alongside other sites.

.DESCRIPTION
    Additive-only: creates a new app pool and a new site bound by hostname
    (SNI), and never touches any other site or app pool on the box. Safe to
    re-run -- each run pulls the latest code, re-syncs the deployed files,
    and recycles the app pool. It does not create/renew the app pool or site
    if they already exist, and it never overwrites secrets.config /
    connectionStrings.config once they've been filled in (see DEPLOYMENT.md).

    Steps:
      1. Verify running elevated.
      2. Install Web-Asp-Net45 / Web-WebSockets Windows Features if missing
         (no-op if already present).
      3. git clone (first run) or git fetch + reset (later runs) the repo
         into -SourcePath, on -Branch.
      4. robocopy /MIR the deploy set (bin\, the two dashboard .aspx files,
         Global.asax, Web.config, Scripts\, css\jquery-ui.min.css,
         images\ground6.png) into -SitePath -- matches deploy-manifest.md.
      5. Seed secrets.config / connectionStrings.config in -SitePath from the
         repo's *.example templates, but ONLY if they don't already exist --
         they are gitignored, so they never come from the git checkout and
         are never overwritten by a redeploy once created. Web.config points
         at both (<appSettings file="secrets.config">,
         <connectionStrings configSource="connectionStrings.config">), so
         the app won't start until the real values are filled in -- see
         DEPLOYMENT.md.
      6. Create the app pool if missing: managedRuntimeVersion v4.0,
         startMode AlwaysRunning, idleTimeout 0 (the app runs a server-side
         polling timer that needs the pool to stay up).
      7. Create the site if missing, bound to -HostName on -HttpPort, with
         Preload Enabled. If -CertificateThumbprint is given, also adds an
         HTTPS binding (SNI, -HttpsPort) with that cert. Otherwise the site
         is HTTP-only, which is correct when a TLS-terminating reverse proxy
         or tunnel (e.g. Cloudflare Tunnel) sits in front of it.
      8. Recycle the app pool so a new bin\admintickets.dll takes effect.

.PARAMETER RepoUrl
    Git URL to clone from. Defaults to the GitHub repo.

.PARAMETER Branch
    Branch to deploy. Default: main.

.PARAMETER SourcePath
    Where to keep the git checkout (source only -- never served directly by
    IIS). Default: C:\src\ticketreporting.

.PARAMETER SitePath
    IIS physical path the site serves from. Default:
    C:\inetpub\wwwroot\admintickets.

.PARAMETER SiteName
    IIS site name. Default: admintickets.

.PARAMETER AppPoolName
    IIS app pool name. Default: admintickets.

.PARAMETER HostName
    DNS hostname this site answers to (used for SNI HTTPS + host-header HTTP
    bindings so it coexists with the other site(s) already on this server).
    Required when creating the site for the first time.

.PARAMETER HttpPort
    HTTP binding port. Default: 80.

.PARAMETER HttpsPort
    HTTPS binding port. Default: 443.

.PARAMETER CertificateThumbprint
    Thumbprint of a certificate already in the machine's Personal (My) store
    to bind to an HTTPS binding via SNI. Optional -- omit it entirely if a
    reverse proxy or tunnel (e.g. Cloudflare Tunnel) terminates TLS in front
    of this site, which then only needs the HTTP binding cloudflared/the
    proxy talks to. Only pass this if IIS itself needs to serve HTTPS
    directly to the internet.

.PARAMETER SkipGit
    Skip the clone/pull step and deploy whatever is currently on disk at
    -SourcePath (e.g. if you already pulled, or are working from a local
    build).

.PARAMETER SkipFeatureCheck
    Skip the Windows Feature install/verify step.

.EXAMPLE
    .\Deploy-ToIIS.ps1 -HostName tickets.example.com

    First-time deploy behind a reverse proxy/tunnel (e.g. Cloudflare Tunnel)
    that terminates TLS -- creates an HTTP-only site on -HttpPort (80).
    Point the proxy/tunnel at http://localhost:80 with Host header
    tickets.example.com.

.EXAMPLE
    .\Deploy-ToIIS.ps1 -HostName tickets.example.com -CertificateThumbprint AB12CD34EF...

    First-time deploy where IIS serves HTTPS directly (no proxy/tunnel in
    front) -- creates the app pool/site with an HTTPS binding using the
    given certificate.

.EXAMPLE
    .\Deploy-ToIIS.ps1

    Redeploy: pulls latest, re-syncs files, recycles the app pool. HostName
    isn't needed once the site already exists.

.NOTES
    Run elevated (Administrator). Idempotent by design -- safe to schedule or
    re-run by hand after every merge to -Branch. Does not compile anything;
    run build.bat first if .vb source changed and bin\admintickets.dll needs
    regenerating.
#>
[CmdletBinding()]
param(
    [string]$RepoUrl = "https://github.com/andycqos74/ticketreporting.git",
    [string]$Branch = "main",
    [string]$SourcePath = "C:\src\ticketreporting",
    [string]$SitePath = "C:\inetpub\wwwroot\admintickets",
    [string]$SiteName = "admintickets",
    [string]$AppPoolName = "admintickets",
    [string]$HostName,
    [int]$HttpPort = 80,
    [int]$HttpsPort = 443,
    [string]$CertificateThumbprint,
    [switch]$SkipGit,
    [switch]$SkipFeatureCheck
)

$ErrorActionPreference = "Stop"

function Assert-Admin {
    $current = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($current)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "Run this script from an elevated (Administrator) PowerShell prompt."
    }
}

function Install-RequiredFeatures {
    Write-Host "Checking Windows Features (Web-Asp-Net45, Web-WebSockets)..." -ForegroundColor Cyan
    $required = "Web-Asp-Net45", "Web-WebSockets"
    $missing = @()
    foreach ($name in $required) {
        $feature = Get-WindowsFeature -Name $name
        if (-not $feature) {
            Write-Warning "Could not query feature '$name' -- skipping check (may not apply to this SKU)."
            continue
        }
        if ($feature.InstallState -ne "Installed") {
            $missing += $name
        }
    }
    if ($missing.Count -gt 0) {
        Write-Host "Installing missing features: $($missing -join ', ')" -ForegroundColor Yellow
        Install-WindowsFeature -Name $missing | Out-Null
    } else {
        Write-Host "Required features already present." -ForegroundColor Green
    }

    $rewriteModule = Get-WebGlobalModule -Name "RewriteModule" -ErrorAction SilentlyContinue
    if (-not $rewriteModule) {
        Write-Warning "URL Rewrite Module 2.0 is not installed. Web.config uses a <rewrite> rule for the HTTPS redirect -- IIS will error on requests until you install it: https://www.iis.net/downloads/microsoft/url-rewrite"
    }
}

function Sync-Repo {
    if ($SkipGit) {
        if (-not (Test-Path $SourcePath)) {
            throw "-SkipGit was given but $SourcePath does not exist."
        }
        Write-Host "Skipping git (per -SkipGit); using existing checkout at $SourcePath" -ForegroundColor Yellow
        return
    }

    if (Test-Path (Join-Path $SourcePath ".git")) {
        Write-Host "Updating existing checkout at $SourcePath (branch $Branch)..." -ForegroundColor Cyan
        Push-Location $SourcePath
        try {
            git fetch origin $Branch
            git checkout $Branch
            git reset --hard "origin/$Branch"
        } finally {
            Pop-Location
        }
    } else {
        Write-Host "Cloning $RepoUrl to $SourcePath (branch $Branch)..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $SourcePath -Force | Out-Null
        git clone --branch $Branch $RepoUrl $SourcePath
    }
}

function Sync-DeployFiles {
    Write-Host "Syncing deploy set into $SitePath..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $SitePath -Force | Out-Null

    robocopy $SourcePath $SitePath dash_display.aspx dash_control.aspx Global.asax Web.config /NFL /NDL /NJH | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed copying top-level files (exit $LASTEXITCODE)" }

    robocopy (Join-Path $SourcePath "bin") (Join-Path $SitePath "bin") /MIR /XF *.pdb *.xml /NFL /NDL /NJH | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed copying bin\ (exit $LASTEXITCODE)" }

    robocopy (Join-Path $SourcePath "Scripts") (Join-Path $SitePath "Scripts") /MIR /NFL /NDL /NJH | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed copying Scripts\ (exit $LASTEXITCODE)" }

    robocopy (Join-Path $SourcePath "css") (Join-Path $SitePath "css") jquery-ui.min.css /NFL /NDL /NJH | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed copying css\ (exit $LASTEXITCODE)" }

    robocopy (Join-Path $SourcePath "images") (Join-Path $SitePath "images") ground6.png /NFL /NDL /NJH | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed copying images\ (exit $LASTEXITCODE)" }

    Write-Host "Deploy set synced." -ForegroundColor Green
}

function Ensure-SecretsFiles {
    $secretsPath = Join-Path $SitePath "secrets.config"
    $secretsExample = Join-Path $SourcePath "secrets.config.example"
    if (-not (Test-Path $secretsPath)) {
        if (Test-Path $secretsExample) {
            Copy-Item $secretsExample $secretsPath
            Write-Warning "Seeded $secretsPath from secrets.config.example -- it has a PLACEHOLDER TicketcoApiToken. Edit it with the real (rotated) token before the app will work."
        } else {
            Write-Warning "secrets.config.example not found in $SourcePath -- create $secretsPath by hand (see DEPLOYMENT.md)."
        }
    }

    $connStringsPath = Join-Path $SitePath "connectionStrings.config"
    $connStringsExample = Join-Path $SourcePath "connectionStrings.config.example"
    if (-not (Test-Path $connStringsPath)) {
        if (Test-Path $connStringsExample) {
            Copy-Item $connStringsExample $connStringsPath
            Write-Warning "Seeded $connStringsPath from connectionStrings.config.example -- it has PLACEHOLDER DB credentials. Edit it with the real (WireGuard-routed, rotated) connection string before the app will work."
        } else {
            Write-Warning "connectionStrings.config.example not found in $SourcePath -- create $connStringsPath by hand (see DEPLOYMENT.md)."
        }
    }
}

function Ensure-AppPool {
    Import-Module WebAdministration

    if (Test-Path "IIS:\AppPools\$AppPoolName") {
        Write-Host "App pool '$AppPoolName' already exists -- leaving its settings as-is." -ForegroundColor Yellow
        return
    }

    Write-Host "Creating app pool '$AppPoolName'..." -ForegroundColor Cyan
    New-WebAppPool -Name $AppPoolName | Out-Null
    Set-ItemProperty "IIS:\AppPools\$AppPoolName" managedRuntimeVersion "v4.0"
    Set-ItemProperty "IIS:\AppPools\$AppPoolName" startMode "AlwaysRunning"
    Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name processModel.idleTimeout -Value ([TimeSpan]::Zero)
}

function Ensure-Site {
    Import-Module WebAdministration

    if (Test-Path "IIS:\Sites\$SiteName") {
        Write-Host "Site '$SiteName' already exists -- leaving its bindings as-is." -ForegroundColor Yellow
        return
    }

    if (-not $HostName) {
        throw "Site '$SiteName' does not exist yet and -HostName was not given. Pass -HostName <dns-name> to create it (bindings are host-header/SNI scoped so they coexist with other sites on this server)."
    }

    Write-Host "Creating site '$SiteName' for host '$HostName'..." -ForegroundColor Cyan
    New-Website -Name $SiteName -PhysicalPath $SitePath -ApplicationPool $AppPoolName `
        -Port $HttpPort -HostHeader $HostName | Out-Null

    if ($CertificateThumbprint) {
        New-WebBinding -Name $SiteName -Protocol https -Port $HttpsPort -HostHeader $HostName -SslFlags 1
        Write-Host "Binding certificate $CertificateThumbprint to https/$HttpsPort ($HostName) via SNI..." -ForegroundColor Cyan
        $appId = "{4dc3e181-e14b-4a21-b022-59fc669b0914}"
        netsh http add sslcert hostnameport="${HostName}:${HttpsPort}" certhash=$CertificateThumbprint appid=$appId certstorename=MY | Out-Null
    } else {
        Write-Host "No -CertificateThumbprint given -- creating an HTTP-only binding (port $HttpPort). This is normal if a reverse proxy or tunnel (e.g. Cloudflare Tunnel) terminates TLS in front of this site -- point it at http://localhost:$HttpPort. If instead this site needs to serve HTTPS directly, re-run with -CertificateThumbprint once you have a certificate." -ForegroundColor Yellow
    }

    Set-ItemProperty "IIS:\Sites\$SiteName" -Name applicationDefaults.preloadEnabled -Value $true
    Write-Host "Site '$SiteName' created." -ForegroundColor Green
}

function Restart-Pool {
    Import-Module WebAdministration
    Write-Host "Recycling app pool '$AppPoolName'..." -ForegroundColor Cyan
    Restart-WebAppPool -Name $AppPoolName
}

Assert-Admin

if (-not $SkipFeatureCheck) {
    Install-RequiredFeatures
}

Sync-Repo
Sync-DeployFiles
Ensure-SecretsFiles
Ensure-AppPool
Ensure-Site
Restart-Pool

Write-Host ""
Write-Host "Deploy complete." -ForegroundColor Green
Write-Host "If secrets.config / connectionStrings.config were just seeded, fill in the real values (see DEPLOYMENT.md) and recycle the app pool again." -ForegroundColor Yellow
