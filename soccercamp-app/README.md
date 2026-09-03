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

## Deploying (Portainer)

The MySQL container is `mysql-tickets`. This app must join whatever Docker
network `mysql-tickets` is already on, so it can reach it by container name.

1. **Find (or create) the shared network.**
   In Portainer: **Networks** -> look for the network `mysql-tickets` is
   attached to (click into it, or check **Containers** -> `mysql-tickets` ->
   its "Network" column/details). Note the exact name — it's often something
   like `<stackname>_default`, not plain `bridge`.

   - If `mysql-tickets` is only on the default `bridge` network (no DNS
     resolution by name there), create a new network instead: **Networks**
     -> **Add network** -> driver `bridge` -> name it e.g. `ticketing_net`.
     Then attach the existing container to it: **Containers** ->
     `mysql-tickets` -> **Join network** -> pick `ticketing_net`. (This adds
     a network to the running container without recreating it.)

2. **Create the stack.**
   Portainer -> **Stacks** -> **Add stack**.
   - *Name*: `soccercamp-app`.
   - *Build method*: either "Repository" (point at this git repo/branch,
     with **Compose path** `soccercamp-app/docker-compose.yml`), or "Web
     editor" and paste the contents of `docker-compose.yml`.
   - Edit the pasted/deployed compose so `networks.shared_net.name` matches
     the real network name from step 1 (e.g. `ticketing_net`).

3. **Set environment variables.**
   In the stack's **Environment variables** section, add the values from
   `.env.example`:
   - `DB_HOST=mysql-tickets`
   - `DB_PORT=3306`
   - `DB_USER` / `DB_PASSWORD` — the same MySQL credentials the rest of the
     dashboard app uses
   - `DB_NAME=qosfctickets`
   - `TICKETCO_API_TOKEN` — the real TicketCo token
   - `SEASON_PASS_ID=1127619`, `TICKET_TYPE_FILTER=Soccer Camps 2026`
     (only needed if you want to override the defaults)

   (Portainer injects these directly, so no `.env` file is needed on the
   host when deploying this way — `env_file: .env` in the compose file is
   only read if the file exists next to it; Portainer's own stack
   environment variables are passed through to the container regardless.)

4. **Deploy the stack.** Portainer builds the image from `Dockerfile` and
   starts the container, joined to the shared network. The
   `soccercamp_tickets` table is created automatically on first startup.

5. Browse to `http://<host>:3000/tickets`, or `/admin` to run the first
   sync from TicketCo.

### Deploying from the CLI instead

```bash
cd soccercamp-app
cp .env.example .env   # fill in DB_HOST=mysql-tickets, credentials, API token
# edit docker-compose.yml's networks.shared_net.name to match mysql-tickets's network
docker compose up -d --build
```

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
