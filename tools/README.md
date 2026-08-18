# Three-season attendance report

`Get-SeasonAttendanceReport.ps1` builds an attendance report straight from the
TicketCo public API — no database, no build step. It covers three seasons:

| Season  | Window (inclusive)      |
|---------|-------------------------|
| 2023/24 | July 2023 – May 2024    |
| 2024/25 | July 2024 – May 2025    |
| 2025/26 | July 2025 – May 2026    |

## Run it

From a PowerShell prompt in the repo root:

```powershell
.\tools\Get-SeasonAttendanceReport.ps1
```

The token is read from `Web.config` (`TicketcoApiToken`) if you don't pass
`-Token`. Three seasons is a lot of `item_grosses` paging, so on a first full
run use a cache and re-run against it for free:

```powershell
.\tools\Get-SeasonAttendanceReport.ps1 -CacheDir .\tc-cache -OutDir .\report-2026
```

`-Refresh` re-downloads over a cache. Only cache finished events — a cached
in-progress event will under-count.

## What comes out

A summary per season on screen, plus three CSVs in `-OutDir`:

| File | Contents |
|------|----------|
| `attendance-by-date.csv` | One row per event date: total / seating / standing check-ins |
| `season-summary.csv`     | The four headline figures per season, with the dates they fell on |
| `sections-by-date.csv`   | Check-ins per section per date — use this to sanity-check the standing split |

The four headline figures, per season:

- **Total attendance** — total checked-in tickets across the season
- **No of occasions** — number of event dates
- **Highest attendance seating** — best single date of (total − standing)
- **Highest attendance standing** — best single date in the standing section

Seating and standing peaks are found independently, so they can land on
different dates.

## Check these two things on the first run

1. **Did it find all three seasons?** The events endpoint serves current events
   by default, so the script asks for a list of status values
   (`active`, `passed`, `past`, `closed`, …), merges the results and
   de-duplicates by event id. A status the API rejects is reported as a warning
   and skipped. If an old season comes back short or empty, run
   `-Discover` to dump what the endpoint actually returns for each status and
   then pass the right ones via `-EventStatus`.

2. **Is the standing split right?** Standing is `section_name -like '*OAKBANK*'`,
   which matches the ground's `OAKBANK SERVICES TERRACE` section as spelled in
   `migration_view.sql`. Everything else counts as seating — including
   `TERREGLES STREET TERRACE` and any `WALK-UP` sections, per the definition of
   seating as "total minus Oakbank". Open `sections-by-date.csv` to see every
   section name the API returned and which bucket it landed in; adjust with
   `-StandingSectionPattern` if a season spells the section differently.

## Counting decisions

These are the judgement calls the script makes. Each one has a switch.

| Decision | Default | Change it with |
|---|---|---|
| Season passes are excluded **as events** (the season-pass product is not an occasion), but a season-ticket holder checking in at a match **counts** towards that match's attendance — it's a person through the gate, which is how the live dashboard counts a head. | Holders counted | `-ExcludeSeasonPassTickets` counts only match-day tickets |
| A ticket counts as checked in if it carries a `checked_in_at` timestamp, matching `vw_ticketsalesreport`. A later check-out does not remove it. | Checked-out still counted | `-ExcludeCheckedOut` |
| A date with no check-ins at all (postponed, never scanned) is listed in the detail CSV but is not counted as an occasion. | Not an occasion | `-IncludeZeroAttendance` |
| A date carrying more than one TicketCo event is one occasion, with the events summed. The summary says so when it happens. | Merged | — |

One ticket counts as one person. The dashboard's per-fixture family-ticket
multipliers live in the database rather than the API, and only cover recent
fixtures, so they are deliberately not applied.

## Testing

Written for Windows PowerShell 5.1 and later. The logic was verified on
PowerShell 7.4 against a mock of the TicketCo API — season windows, the
grouping of two events onto one date, exclusion of season-pass events, undated
and out-of-range events, zero-attendance dates, seasons with no events at all,
paging, caching, and each of the switches above — with every figure checked
against independently calculated expected values. It has **not** yet been run
against the live API.
