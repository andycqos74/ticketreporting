<#
.SYNOPSIS
    Three-season attendance report from the TicketCo public API, grouped by
    event date and broken down by season.

.DESCRIPTION
    Pulls every TicketCo *Event* (season passes are a separate TicketCo entity
    and are excluded -- see NOTES), works out each event's date from its
    start_at, then pulls that event's item_grosses feed and counts check-ins.

    Per season it reports:

      Total attendance ........... total checked-in tickets
      No of occasions ............ number of event dates
      Highest attendance seating . best single date of (total - standing)
      Highest attendance standing  best single date in the standing section

    Seating and standing maxima are found independently, so they can (and often
    will) come from different dates.

    Output: a summary on screen plus CSVs in -OutDir.

.PARAMETER Token
    TicketCo public API token. Defaults to the TicketcoApiToken appSetting in
    Web.config (looked up next to the script, then in its parent folder, or use
    -WebConfigPath).

.PARAMETER StandingSectionPattern
    Wildcard matched against item_grosses section_name to identify the standing
    terrace. Defaults to '*OAKBANK*', which matches the ground's
    'OAKBANK SERVICES TERRACE' section as spelled in the live dashboard view.
    Everything checked in outside this pattern counts as seating.

.PARAMETER EventStatus
    Status values to ask the events endpoint for. The endpoint returns current
    events by default, so past seasons need the archived/passed statuses too.
    Results from every status are merged and de-duplicated by event id, and a
    status the API rejects is reported and skipped -- so an extra guess costs
    nothing. Use -Discover to see what your account actually returns.

.PARAMETER ExcludeSeasonPassTickets
    Off by default. By default a season-ticket holder's admission at the
    turnstile COUNTS towards attendance -- it is a person through the gate, and
    it matches how the live dashboard counts a head. Switch this on to count
    only match-day tickets (item_type_type not SeasonPassType /
    SeasonPassShadowType).

.PARAMETER ExcludeCheckedOut
    Off by default. By default any ticket carrying a checked_in_at timestamp
    counts, which is how vw_ticketsalesreport counts check-ins. Switch this on
    to discount tickets that were later checked out again.

.PARAMETER IncludeZeroAttendance
    Off by default. By default a date with no check-ins at all is listed in the
    detail CSV but is not counted as an occasion. Switch this on to count every
    event date in the window, attended or not.

.PARAMETER CacheDir
    Optional folder to cache each event's item_grosses feed, so re-runs do not
    re-download three seasons. Use -Refresh to bypass an existing cache. Only
    cache completed events -- a cached in-progress event will under-count.

.PARAMETER Discover
    Fetch only the first page of each status and write the raw JSON to -OutDir,
    without building a report. Use this if the event list comes back empty or
    short, to see what the API really returns.

.EXAMPLE
    .\Get-SeasonAttendanceReport.ps1

.EXAMPLE
    .\Get-SeasonAttendanceReport.ps1 -CacheDir .\tc-cache -OutDir .\report-2026

.NOTES
    "Only Events, ignore season passes" is applied at the EVENT level: the
    events endpoint is queried with type=Event, and anything the API reports as
    a season-pass type is dropped, so the season-pass product itself never
    appears as an occasion. Season-pass HOLDERS checking in at a match are
    still counted in that match's attendance (see -ExcludeSeasonPassTickets).

    One ticket counts as one person. The dashboard's per-fixture family-ticket
    multipliers live in the database, not in the API, and only cover recent
    fixtures, so they are deliberately not applied here.

    Written for Windows PowerShell 5.1 and later.
#>

[CmdletBinding()]
param(
    [string]   $Token,
    [string]   $ApiRoot = 'https://ticketco.events/api/public/v1/',
    [string]   $WebConfigPath,
    [string]   $OutDir = (Join-Path (Get-Location).Path 'report-output'),
    [string]   $StandingSectionPattern = '*OAKBANK*',
    [string[]] $EventStatus = @('active', 'passed', 'past', 'closed', 'finished', 'inactive', 'archived', 'expired'),
    [string[]] $EventId,
    [switch]   $ExcludeSeasonPassTickets,
    [switch]   $ExcludeCheckedOut,
    [switch]   $IncludeZeroAttendance,
    [string]   $CacheDir,
    [switch]   $Refresh,
    [int]      $DelayMs = 150,
    [int]      $MaxPages = 500,
    [switch]   $Discover
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

# TicketCo is HTTPS / TLS 1.2 only.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$UserAgent = 'QOSFC-SeasonReport/1.0'

# The three seasons, inclusive of both end dates.
$Seasons = @(
    [pscustomobject]@{ Name = '2023/24'; Start = [datetime]'2023-07-01'; End = [datetime]'2024-05-31' }
    [pscustomobject]@{ Name = '2024/25'; Start = [datetime]'2024-07-01'; End = [datetime]'2025-05-31' }
    [pscustomobject]@{ Name = '2025/26'; Start = [datetime]'2025-07-01'; End = [datetime]'2026-05-31' }
)

# ---------------------------------------------------------------------------
#  Helpers
# ---------------------------------------------------------------------------

function Resolve-ApiToken {
    param([string]$Explicit, [string]$ConfigPath)

    if (-not [string]::IsNullOrWhiteSpace($Explicit)) { return $Explicit }

    $candidates = New-Object System.Collections.Generic.List[string]
    if (-not [string]::IsNullOrWhiteSpace($ConfigPath)) { $candidates.Add($ConfigPath) }
    $here = Split-Path -Parent $PSCommandPath
    $candidates.Add((Join-Path $here 'Web.config'))
    $candidates.Add((Join-Path (Split-Path -Parent $here) 'Web.config'))
    $candidates.Add((Join-Path (Get-Location).Path 'Web.config'))

    foreach ($path in $candidates) {
        if (-not (Test-Path -LiteralPath $path)) { continue }
        try {
            $xml = [xml](Get-Content -LiteralPath $path -Raw)
            foreach ($add in $xml.configuration.appSettings.add) {
                if ($add.key -eq 'TicketcoApiToken' -and -not [string]::IsNullOrWhiteSpace($add.value)) {
                    Write-Verbose "Token read from $path"
                    return $add.value
                }
            }
        } catch {
            Write-Warning "Could not read $path : $($_.Exception.Message)"
        }
    }

    throw "No API token. Pass -Token, or put TicketcoApiToken in a Web.config the script can find (-WebConfigPath)."
}

# Keep the token out of anything we print.
function Hide-Token {
    param([string]$Text, [string]$Secret)
    if ([string]::IsNullOrWhiteSpace($Secret)) { return $Text }
    return $Text.Replace($Secret, '<token>')
}

function Get-StatusCode {
    param($ErrorRecord)
    try {
        $response = $ErrorRecord.Exception.Response
        if ($null -eq $response) { return 0 }
        return [int]$response.StatusCode
    } catch {
        return 0
    }
}

function Invoke-TcRequest {
    param([string]$Url, [switch]$Raw, [int]$Retries = 4)

    $attempt = 0
    while ($true) {
        $attempt++
        try {
            if ($Raw) {
                return (Invoke-WebRequest -Uri $Url -UserAgent $UserAgent -TimeoutSec 180 -UseBasicParsing).Content
            }
            return Invoke-RestMethod -Uri $Url -UserAgent $UserAgent -TimeoutSec 180
        } catch {
            $code = Get-StatusCode $_
            # 4xx (other than rate limiting) is an answer, not a glitch: no retry.
            if ($code -ge 400 -and $code -lt 500 -and $code -ne 429) {
                throw "HTTP $code from $(Hide-Token $Url $script:ApiToken)"
            }
            if ($attempt -ge $Retries) {
                throw "$($_.Exception.Message) -- $(Hide-Token $Url $script:ApiToken)"
            }
            $wait = [math]::Pow(2, $attempt)
            Write-Verbose "Attempt $attempt failed ($code); retrying in $wait s"
            Start-Sleep -Seconds $wait
        }
    }
}

function Get-Prop {
    param($Object, [string]$Name)
    if ($null -eq $Object) { return $null }
    try {
        if ($Object.PSObject.Properties.Match($Name).Count -eq 0) { return $null }
        return $Object.$Name
    } catch {
        return $null
    }
}

function Get-Text {
    param($Object, [string]$Name)
    $value = Get-Prop $Object $Name
    if ($null -eq $value) { return '' }
    return ([string]$value).Trim()
}

# start_at may arrive as a string or, depending on the PowerShell version's JSON
# parser, already converted to a date. Handle both, and keep the venue-local
# wall time rather than shifting the date into UTC.
function ConvertTo-EventDate {
    param($Value)

    if ($null -eq $Value) { return $null }
    if ($Value -is [datetime])       { return $Value.Date }
    if ($Value -is [datetimeoffset]) { return $Value.DateTime.Date }

    $text = ([string]$Value).Trim()
    if ([string]::IsNullOrWhiteSpace($text)) { return $null }

    $culture = [System.Globalization.CultureInfo]::InvariantCulture
    $styles  = [System.Globalization.DateTimeStyles]::None

    $dto = [datetimeoffset]::MinValue
    if ([datetimeoffset]::TryParse($text, $culture, $styles, [ref]$dto)) { return $dto.DateTime.Date }

    $dt = [datetime]::MinValue
    if ([datetime]::TryParse($text, $culture, $styles, [ref]$dt)) { return $dt.Date }

    if ($text.Length -ge 10) {
        if ([datetime]::TryParseExact($text.Substring(0, 10), 'yyyy-MM-dd', $culture, $styles, [ref]$dt)) { return $dt.Date }
    }
    return $null
}

function Get-SeasonFor {
    param([datetime]$Date)
    foreach ($season in $Seasons) {
        if ($Date -ge $season.Start -and $Date -le $season.End) { return $season.Name }
    }
    return $null
}

function Get-Sum {
    param($Items, [string]$Property)
    $total = 0
    foreach ($item in $Items) { $total += [int]$item.$Property }
    return $total
}

function ConvertTo-Array {
    param($Value)
    # The comma operator stops PowerShell unrolling a one-element array (or
    # turning an empty one into $null) on the way out of the function.
    if ($null -eq $Value) { return , @() }
    if ($Value -is [System.Array]) { return , $Value }
    return , @($Value)
}

# ---------------------------------------------------------------------------
#  API: events
# ---------------------------------------------------------------------------

function Get-TcEventPage {
    param([string]$Status, [int]$Page)

    $url = '{0}events?token={1}&type=Event&page={2}' -f `
        $script:ApiRoot, [uri]::EscapeDataString($script:ApiToken), $Page
    if (-not [string]::IsNullOrWhiteSpace($Status)) {
        $url += '&status=' + [uri]::EscapeDataString($Status)
    }
    return Invoke-TcRequest $url
}

function Get-TcEvents {
    $byId = New-Object 'System.Collections.Generic.Dictionary[string,object]'
    $order = New-Object System.Collections.Generic.List[string]

    foreach ($status in $EventStatus) {
        $label = if ([string]::IsNullOrWhiteSpace($status)) { '(no status)' } else { $status }
        $seenThisStatus = New-Object 'System.Collections.Generic.HashSet[string]'
        $fromThisStatus = 0
        $page = 1

        while ($page -le $MaxPages) {
            try {
                $response = Get-TcEventPage -Status $status -Page $page
            } catch {
                Write-Warning "events (status=$label, page=$page): $($_.Exception.Message)"
                break
            }

            $items = ConvertTo-Array (Get-Prop $response 'events')
            if ($items.Count -eq 0 -and $response -is [System.Array]) { $items = ConvertTo-Array $response }
            if ($items.Count -eq 0) { break }

            # Guard against an API that ignores &page and keeps serving page 1.
            $newOnThisPage = 0
            foreach ($ev in $items) {
                $id = Get-Text $ev 'id'
                if ([string]::IsNullOrWhiteSpace($id)) { continue }
                if ($seenThisStatus.Add($id)) { $newOnThisPage++ }
                if (-not $byId.ContainsKey($id)) {
                    $byId[$id] = $ev
                    $order.Add($id)
                    $fromThisStatus++
                }
            }
            if ($newOnThisPage -eq 0) { break }

            $page++
            if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
        }

        Write-Host ("  status={0,-10} new events: {1}" -f $label, $fromThisStatus)
    }

    $result = New-Object System.Collections.Generic.List[object]
    foreach ($id in $order) { $result.Add($byId[$id]) }
    return , $result.ToArray()
}

# Season passes are a separate TicketCo entity, but be explicit rather than
# trusting the type=Event query alone.
function Test-IsSeasonPassEvent {
    param($Event)
    foreach ($field in @('type', 'event_type', 'kind')) {
        $value = Get-Text $Event $field
        if ($value -and $value -match 'season') { return $true }
    }
    return $false
}

# ---------------------------------------------------------------------------
#  API: item_grosses
# ---------------------------------------------------------------------------

function Get-TcItemGrosses {
    param([string]$Id)

    $cacheFile = $null
    if (-not [string]::IsNullOrWhiteSpace($CacheDir)) {
        if (-not (Test-Path -LiteralPath $CacheDir)) { New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null }
        $cacheFile = Join-Path $CacheDir ("event-{0}.json" -f $Id)
        if ((Test-Path -LiteralPath $cacheFile) -and -not $Refresh) {
            try {
                $cached = ConvertTo-Array (Get-Content -LiteralPath $cacheFile -Raw | ConvertFrom-Json)
                return , $cached
            } catch {
                Write-Warning "Cache unreadable for event $Id, refetching: $($_.Exception.Message)"
            }
        }
    }

    $rows = New-Object System.Collections.Generic.List[object]
    $page = 1
    while ($page -le $MaxPages) {
        $url = '{0}item_grosses?token={1}&event_id={2}&page={3}' -f `
            $script:ApiRoot, [uri]::EscapeDataString($script:ApiToken), [uri]::EscapeDataString($Id), $page

        $response = Invoke-TcRequest $url
        $items = ConvertTo-Array (Get-Prop $response 'item_grosses')
        if ($items.Count -eq 0) { break }

        foreach ($item in $items) { $rows.Add($item) }
        $page++
        if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
    }

    if ($cacheFile) {
        try {
            ConvertTo-Json -InputObject $rows.ToArray() -Depth 12 | Set-Content -LiteralPath $cacheFile -Encoding UTF8
        } catch {
            Write-Warning "Could not cache event $Id : $($_.Exception.Message)"
        }
    }
    return , $rows.ToArray()
}

# ---------------------------------------------------------------------------
#  Counting
# ---------------------------------------------------------------------------

function Measure-EventAttendance {
    param($Rows)

    $total = 0
    $standing = 0
    $sections = New-Object 'System.Collections.Generic.Dictionary[string,int]'

    foreach ($row in (ConvertTo-Array $Rows)) {
        if ($ExcludeSeasonPassTickets) {
            $itemType = Get-Text $row 'item_type_type'
            if ($itemType -match 'SeasonPass') { continue }
        }

        if ([string]::IsNullOrWhiteSpace((Get-Text $row 'checked_in_at'))) { continue }
        if ($ExcludeCheckedOut -and -not [string]::IsNullOrWhiteSpace((Get-Text $row 'checked_out_at'))) { continue }

        $total++

        $section = Get-Text $row 'section_name'
        if ([string]::IsNullOrWhiteSpace($section)) { $section = '(no section)' }
        if ($sections.ContainsKey($section)) { $sections[$section] += 1 } else { $sections[$section] = 1 }

        if ($section -like $StandingSectionPattern) { $standing++ }
    }

    return [pscustomobject]@{
        Total    = $total
        Standing = $standing
        Seating  = $total - $standing
        Sections = $sections
    }
}

# ---------------------------------------------------------------------------
#  Run
# ---------------------------------------------------------------------------

$script:ApiToken = Resolve-ApiToken -Explicit $Token -ConfigPath $WebConfigPath
$script:ApiRoot  = $ApiRoot
if (-not $script:ApiRoot.EndsWith('/')) { $script:ApiRoot += '/' }

if (-not (Test-Path -LiteralPath $OutDir)) { New-Item -ItemType Directory -Path $OutDir -Force | Out-Null }
$OutDir = (Resolve-Path -LiteralPath $OutDir).Path

if ($Discover) {
    Write-Host "Discovery mode: writing first-page responses to $OutDir`n"
    foreach ($status in $EventStatus) {
        $label = if ([string]::IsNullOrWhiteSpace($status)) { 'none' } else { $status }
        $url = '{0}events?token={1}&type=Event&page=1' -f $script:ApiRoot, [uri]::EscapeDataString($script:ApiToken)
        if ($status) { $url += '&status=' + [uri]::EscapeDataString($status) }
        try {
            $raw = Invoke-TcRequest $url -Raw
            $file = Join-Path $OutDir ("discover-events-{0}.json" -f $label)
            Set-Content -LiteralPath $file -Value $raw -Encoding UTF8
            Write-Host ("  status={0,-10} {1,9:N0} bytes -> {2}" -f $label, $raw.Length, (Split-Path -Leaf $file))
        } catch {
            Write-Host ("  status={0,-10} FAILED: {1}" -f $label, $_.Exception.Message)
        }
    }
    return
}

Write-Host "TicketCo three-season attendance report"
Write-Host "  seasons  : $(($Seasons | ForEach-Object { $_.Name }) -join ', ')"
Write-Host "  standing : section_name -like '$StandingSectionPattern'"
Write-Host "  output   : $OutDir"
Write-Host ""
Write-Host "Fetching events..."

$allEvents = Get-TcEvents
Write-Host ("  {0} distinct events returned`n" -f $allEvents.Count)

# Keep only real events dated inside one of the three seasons.
$inScope = New-Object System.Collections.Generic.List[object]
$skippedSeasonPass = 0
$skippedNoDate = 0
$skippedOutOfRange = 0

foreach ($ev in $allEvents) {
    $id = Get-Text $ev 'id'
    if ([string]::IsNullOrWhiteSpace($id)) { continue }
    if ($EventId -and ($EventId -notcontains $id)) { continue }

    if (Test-IsSeasonPassEvent $ev) { $skippedSeasonPass++; continue }

    $date = ConvertTo-EventDate (Get-Prop $ev 'start_at')
    if ($null -eq $date) { $skippedNoDate++; continue }

    $season = Get-SeasonFor $date
    if ($null -eq $season) { $skippedOutOfRange++; continue }

    $inScope.Add([pscustomobject]@{
        Id     = $id
        Title  = Get-Text $ev 'title'
        Date   = $date
        Season = $season
    })
}

Write-Host ("  in scope: {0}   (skipped: {1} season-pass, {2} undated, {3} outside the three seasons)`n" -f `
    $inScope.Count, $skippedSeasonPass, $skippedNoDate, $skippedOutOfRange)

if ($inScope.Count -eq 0) {
    Write-Warning "No events fell inside the three seasons. Re-run with -Discover to see what the events endpoint returns for your token."
    return
}

# Per-event check-in counts.
$eventRows = New-Object System.Collections.Generic.List[object]
$sectionRows = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($ev in ($inScope | Sort-Object Date, Id)) {
    $index++
    Write-Progress -Activity 'Reading item_grosses' -Status ("{0} ({1:yyyy-MM-dd}) {2}" -f $ev.Id, $ev.Date, $ev.Title) `
                   -PercentComplete ([int](100 * $index / $inScope.Count))

    try {
        $counts = Measure-EventAttendance (Get-TcItemGrosses $ev.Id)
    } catch {
        Write-Warning "event $($ev.Id) ($($ev.Title)): $($_.Exception.Message)"
        continue
    }

    $eventRows.Add([pscustomobject]@{
        Season        = $ev.Season
        EventDate     = $ev.Date
        EventId       = $ev.Id
        EventName     = $ev.Title
        TotalCheckedIn    = $counts.Total
        SeatingCheckedIn  = $counts.Seating
        StandingCheckedIn = $counts.Standing
    })

    foreach ($section in ($counts.Sections.Keys | Sort-Object)) {
        $sectionRows.Add([pscustomobject]@{
            Season      = $ev.Season
            EventDate   = $ev.Date
            EventId     = $ev.Id
            EventName   = $ev.Title
            Section     = $section
            CheckedIn   = $counts.Sections[$section]
            CountsAs    = if ($section -like $StandingSectionPattern) { 'standing' } else { 'seating' }
        })
    }
}
Write-Progress -Activity 'Reading item_grosses' -Completed

# Group by event date -- one date is one occasion, even if it carries more than
# one TicketCo event.
$dateRows = New-Object System.Collections.Generic.List[object]
foreach ($group in ($eventRows | Group-Object Season, EventDate)) {
    $first = $group.Group[0]
    $names = ($group.Group | ForEach-Object { $_.EventName } | Select-Object -Unique) -join ' + '
    $ids   = ($group.Group | ForEach-Object { $_.EventId }) -join ' + '
    $total    = Get-Sum $group.Group 'TotalCheckedIn'
    $seating  = Get-Sum $group.Group 'SeatingCheckedIn'
    $standing = Get-Sum $group.Group 'StandingCheckedIn'

    $dateRows.Add([pscustomobject]@{
        Season            = $first.Season
        EventDate         = $first.EventDate
        EventName         = $names
        EventIds          = $ids
        Events            = $group.Group.Count
        TotalCheckedIn    = [int]$total
        SeatingCheckedIn  = [int]$seating
        StandingCheckedIn = [int]$standing
        IsOccasion        = ($IncludeZeroAttendance -or $total -gt 0)
    })
}
$dateRows = $dateRows | Sort-Object Season, EventDate

# Season summary.
$summaryRows = New-Object System.Collections.Generic.List[object]
foreach ($season in $Seasons) {
    $dates = @($dateRows | Where-Object { $_.Season -eq $season.Name })
    $counted = @($dates | Where-Object { $_.IsOccasion })

    $bestSeating  = $counted | Sort-Object SeatingCheckedIn  -Descending | Select-Object -First 1
    $bestStanding = $counted | Sort-Object StandingCheckedIn -Descending | Select-Object -First 1
    $total = Get-Sum $counted 'TotalCheckedIn'

    $summaryRows.Add([pscustomobject]@{
        Season                   = $season.Name
        From                     = $season.Start
        To                       = $season.End
        TotalAttendance          = [int]$total
        Occasions                = $counted.Count
        Events                   = Get-Sum $counted 'Events'
        HighestSeating           = if ($bestSeating)  { $bestSeating.SeatingCheckedIn }   else { 0 }
        HighestSeatingDate       = if ($bestSeating)  { $bestSeating.EventDate }          else { $null }
        HighestSeatingEvent      = if ($bestSeating)  { $bestSeating.EventName }          else { '' }
        HighestStanding          = if ($bestStanding) { $bestStanding.StandingCheckedIn } else { 0 }
        HighestStandingDate      = if ($bestStanding) { $bestStanding.EventDate }         else { $null }
        HighestStandingEvent     = if ($bestStanding) { $bestStanding.EventName }         else { '' }
        AverageAttendance        = if ($counted.Count -gt 0) { [math]::Round($total / $counted.Count, 0) } else { 0 }
    })
}

# ---------------------------------------------------------------------------
#  Output
# ---------------------------------------------------------------------------

$byDateCsv  = Join-Path $OutDir 'attendance-by-date.csv'
$summaryCsv = Join-Path $OutDir 'season-summary.csv'
$sectionCsv = Join-Path $OutDir 'sections-by-date.csv'

$dateRows    | Select-Object Season, @{n='EventDate';e={$_.EventDate.ToString('yyyy-MM-dd')}}, EventName, EventIds, Events,
                             TotalCheckedIn, SeatingCheckedIn, StandingCheckedIn, IsOccasion |
               Export-Csv -LiteralPath $byDateCsv -NoTypeInformation -Encoding UTF8
$summaryRows | Export-Csv -LiteralPath $summaryCsv -NoTypeInformation -Encoding UTF8
$sectionRows | Select-Object Season, @{n='EventDate';e={$_.EventDate.ToString('yyyy-MM-dd')}}, EventId, EventName, Section, CheckedIn, CountsAs |
               Export-Csv -LiteralPath $sectionCsv -NoTypeInformation -Encoding UTF8

foreach ($season in $Seasons) {
    $rows = @($dateRows | Where-Object { $_.Season -eq $season.Name -and $_.IsOccasion })
    if ($rows.Count -eq 0) { continue }
    Write-Host ""
    Write-Host ("{0}  ({1:dd MMM yyyy} - {2:dd MMM yyyy})" -f $season.Name, $season.Start, $season.End)
    $rows | Format-Table -AutoSize `
                @{ Name = 'Date';     Expression = { $_.EventDate.ToString('ddd dd MMM yyyy') } },
                @{ Name = 'Event';    Expression = { $_.EventName }; Width = 44 },
                @{ Name = 'Total';    Expression = { $_.TotalCheckedIn };    Alignment = 'Right' },
                @{ Name = 'Seating';  Expression = { $_.SeatingCheckedIn };  Alignment = 'Right' },
                @{ Name = 'Standing'; Expression = { $_.StandingCheckedIn }; Alignment = 'Right' } |
           Out-String -Width 110 | Write-Host
}

Write-Host ""
Write-Host "==================== SEASON SUMMARY ===================="
foreach ($row in $summaryRows) {
    Write-Host ""
    Write-Host $row.Season
    Write-Host ("  Total attendance ............ {0,8:N0}" -f $row.TotalAttendance)
    Write-Host ("  No of occasions ............. {0,8:N0}" -f $row.Occasions)
    if ($row.Events -ne $row.Occasions) {
        Write-Host ("    (across {0:N0} TicketCo events -- some dates carry more than one)" -f $row.Events)
    }
    Write-Host ("  Highest attendance seating .. {0,8:N0}   {1}" -f $row.HighestSeating,
        $(if ($row.HighestSeatingDate) { "{0:ddd dd MMM yyyy} - {1}" -f $row.HighestSeatingDate, $row.HighestSeatingEvent } else { '' }))
    Write-Host ("  Highest attendance standing . {0,8:N0}   {1}" -f $row.HighestStanding,
        $(if ($row.HighestStandingDate) { "{0:ddd dd MMM yyyy} - {1}" -f $row.HighestStandingDate, $row.HighestStandingEvent } else { '' }))
    Write-Host ("  Average per occasion ........ {0,8:N0}" -f $row.AverageAttendance)
}

Write-Host ""
Write-Host "CSVs written:"
Write-Host "  $byDateCsv"
Write-Host "  $summaryCsv"
Write-Host "  $sectionCsv"
Write-Host ""
Write-Host "Check sections-by-date.csv to confirm '$StandingSectionPattern' is catching every standing section."
