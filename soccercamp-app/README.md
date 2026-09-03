# Soccer Camps 2026 - Shirt Collection Tracker

Standalone Node.js/Express app, run as its own Docker container, that lets
soccer-camp kids present their free TicketCo season ticket to collect their
free replica shirt - with tracking so each kid only gets one shirt.

Pulls season-ticket holders from TicketCo season pass **1127619**, ticket
type **"Soccer Camps 2026"**, into a new table (`soccercamp_tickets`) in the
existing `qosfctickets` MySQL database (the same database the rest of this
repo's dashboard uses). The table is created automatically on startup if it
doesn't exist (see `schema.sql`).

## Pages

- **`/admin`** - "Sync Now" button: pulls the current list of ticket holders
  from the TicketCo API and upserts them. Never touches existing "Collected"
  status or shirt size.
- **`/tickets`** - list of every ticket, with a Collected/Not collected
  filter and a name/reference search.
- **`/collect`** - enter a ticket ID/reference, or scan the ticket's QR code
  with a device camera. Shows the holder's name, ticket type, and current
  "Collected" status, and a form to record the shirt size and mark it
  collected. If a ticket is already marked collected, the button is guarded
  behind an explicit "Override" checkbox so a shirt isn't accidentally issued
  twice.

QR scanning uses the [html5-qrcode](https://github.com/mebjas/html5-qrcode)
library from a CDN and needs camera access, which browsers only grant on
`https://` or `localhost` - run this behind the same TLS-terminating
proxy/tunnel as the rest of the site (or over `http://localhost` for local
testing).

## Running with Docker

1. Copy `.env.example` to `.env` and fill in the real DB credentials and
   TicketCo API token (the same token used elsewhere in this repo).
2. Point this container at your existing MySQL container's Docker network so
   it can reach it by container/service name:

   ```bash
   docker inspect <mysql_container_name> --format '{{json .NetworkSettings.Networks}}'
   ```

   Edit `docker-compose.yml`'s `networks.shared_net.name` to match, and set
   `DB_HOST` in `.env` to the MySQL container's name (or service name, if
   MySQL is itself defined in a compose file on that same network).

3. Build and start:

   ```bash
   docker compose up -d --build
   ```

4. Browse to `http://<host>:3000/tickets` (or `/admin` to run the first
   sync).

## Running without Docker (local dev)

```bash
npm install
cp .env.example .env   # fill in DB_HOST=localhost etc. and the API token
npm start
```

## Environment variables

See `.env.example`. `SEASON_PASS_ID` and `TICKET_TYPE_FILTER` default to
`1127619` and `Soccer Camps 2026` respectively, and only need overriding if
next year's camp uses a different season pass or ticket-type title.
