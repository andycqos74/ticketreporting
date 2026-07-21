# TicketCo Dashboard — Code Review & Refactor Notes

Review of the ticket-reporting app plus a refactor that removes n8n from the
loop and makes the TicketCo API call and the dashboard push happen in **one
place**, on the server.

---

## 1. How the system worked before

```
n8n (external cron) ──► import_JSON.php ──► TicketCo API (item_grosses)
                                                     │  REPLACE INTO
                                                     ▼
                                          MySQL: ticketco_matchsales
                                                     │  aggregated by
                                                     ▼
                                          view: vw_ticketsalesreport
                                                     ▲
dash_control.aspx (browser tab open) ─ setInterval ─┘ calls hub.populateDataTable
                                                     │
                                          SignalR broadcastMessage
                                                     ▼
                                          dash_display.aspx (receiver)
```

Two independent clocks drove the system:

1. **n8n** decided when to import (API → DB).
2. **A browser tab** open on `dash_control.aspx` decided when to broadcast
   (DB → screen), via a client-side `setInterval`.

Nothing synchronised the two, which is the timing issue you described: a
broadcast could fire before an import finished, and if the control tab was
closed, updates stopped entirely.

## 2. How it works now

```
Application_Start ─► TicketcoPoller (one server-side timer)
        each tick, in strict order:
           1. TicketcoImporter.FetchAndStore  → TicketCo API → REPLACE INTO ticketco_matchsales
           2. ChatHubticketco.PopulateDataTable → read vw_ticketsalesreport → SignalR broadcast

dash_control.aspx ─► chat.server.startPolling(fixtureId, interval)  (sets target, can close tab)
                     chat.server.stopPolling()
dash_display.aspx ─► pure receiver; asks for one paint on connect, then just listens
```

- **The API call and the push are the same operation** (`TicketcoPoller.Tick`),
  in order, so a push always reflects a completed import.
- **No n8n and no open browser tab** are required — the loop runs inside the web
  app.
- The poll target (fixture + interval) is set either from `dash_control.aspx`
  at runtime, or from `Web.config` at startup (`TicketcoAutoStart`).

### Files changed

| File | Change |
|------|--------|
| `ChatHubticketco.vb` | Implemented real `ImportJSON`; added `StartPolling`/`StopPolling` hub methods; added `TicketcoImporter` (VB port of `import_JSON.php`, parameterised) and `TicketcoPoller` (server timer with a re-entrancy guard). |
| `Global.asax.vb` | `Application_Start` now calls `TicketcoPoller.AutoStartFromConfig()`. |
| `Web.config` | Added `appSettings`: `TicketcoApiToken`, `TicketcoActiveEventId`, `TicketcoPollSeconds`, `TicketcoAutoStart`. |
| `dash_display.aspx` | Rewrote the connection lifecycle: single self-healing connect/reconnect, requests one paint on connect, shows "Reconnecting…" when the feed drops. Broadcast contract and all element IDs unchanged. |
| `dash_control.aspx` | Start/Stop now drive the **server** loop instead of a browser `setInterval`. |

### The TicketCo API (for reference)

- Endpoint used: `GET https://ticketco.events/api/public/v1/item_grosses?token=<TOKEN>&event_id=<ID>&page=<N>`
- Auth: `token` query parameter.
- Pagination: increment `page` until `item_grosses` comes back empty.
- Fields consumed per line: `transaction_datestamp`, `ref_number`,
  `section_name`, `item_type_title`, `event_name`, `checked_in_at`,
  `checked_out_at`, `check_in_user_id`, `item_type_type`.
- `item_grosses` is per-event and immutable once an event has ended, so ended
  fixtures never need re-polling.

---

## 3. Security findings — please action

These are **live secrets committed to git history**. Moving/removing them now
does **not** undo the exposure — they must be rotated.

| # | What | Where | Action |
|---|------|-------|--------|
| 1 | MySQL user/password (`qosfclivedb` / `P@ssword1919`) | `Web.config` connection strings; hardcoded in `import_JSON.php` | **Rotate the DB password.** Then keep it out of source (e.g. `configSource`/`appSettings file=` pointing at an un-committed file). |
| 2 | TicketCo API token (`nk6t4EzmDNuB3vAZ1gMy`) | `import_JSON.php`, `JSONtest.aspx.vb`, now `Web.config` | **Rotate the token with TicketCo.** It is now read from one config key, but the old value is in history. |
| 3 | Cleartext app login passwords (Andy/Dan/Eric/…) | `Web.config` `<credentials passwordFormat="Clear">` | Change these passwords; consider hashing or a proper user store. |
| 4 | SQL injection | `import_JSON.php` builds SQL by string interpolation | The VB replacement (`TicketcoImporter`) is fully parameterised. Retire the PHP importer once you cut over. |
| 5 | `Process.Start(webAddress)` on the server | `JSONtest.aspx.vb` | Launches a browser process on the web server on every page load — remove; the file is a dead test now. |
| 6 | `customErrors mode="Off"` + `debug="true"` + `Access-Control-Allow-Origin: *` | `Web.config` | Turn errors off / debug off for production; scope CORS to the dashboard origin instead of `*`. |

> Because rotation is required regardless, I left credential **values** in place
> so nothing breaks on your next deploy — but items 1–3 are not optional.

---

## 4. Deploying this change

This environment has no .NET build tools, so the code here is **not compiled**.
Build and deploy from Visual Studio:

1. Open the solution in Visual Studio. Confirm the modified `.vb`/`.aspx` files
   are part of the project (they were already tracked, so they should be).
2. Set `Web.config` values:
   - `TicketcoApiToken` — the (rotated) token.
   - `TicketcoActiveEventId` — default fixture.
   - `TicketcoPollSeconds` — e.g. `30`.
   - `TicketcoAutoStart` — `true` to run automatically on app start, or `false`
     to control it from `dash_control.aspx`.
3. Rebuild (this regenerates `bin/admintickets.dll`) and publish to the server.
4. Verify: open `dash_display.aspx` — it should paint on connect and refresh on
   each poll tick. If `TicketcoAutoStart=false`, press **Start** on
   `dash_control.aspx`.
5. Once confirmed, **disable the n8n workflow** and retire `import_JSON.php` /
   `JSONtest.aspx`.

### Notes / assumptions

- On IIS, a background `System.Threading.Timer` stops when the app pool is
  recycled or idle-unloaded. For always-on polling, set the app pool to
  **AlwaysRunning** + a **Preload** enabled site, or disable idle timeout.
  `TicketcoAutoStart=true` then re-arms the loop after each recycle.
- `TicketcoImporter` preserves the exact check-in/turnstile mapping and the
  `ticketco_matchsales` columns the PHP script wrote, so `vw_ticketsalesreport`
  and the dashboard need no changes.
- The SignalR `broadcastMessage` argument order is a contract between
  `PopulateDataTable` and `dash_display.aspx`; keep them in sync if you edit it.
