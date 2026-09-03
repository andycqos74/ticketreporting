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

## Image build

The image is **built by GitHub Actions**, not by Portainer — building on the
Portainer host itself was running into memory limits. `.github/workflows/soccercamp-app-image.yml`
builds `soccercamp-app/Dockerfile` and pushes it to GitHub Container Registry
as `ghcr.io/andycqos74/soccercamp-app:latest` (and `:<commit-sha>`) on every
push to `main`/`master`/`claude/**` that touches `soccercamp-app/**`. Portainer
then just pulls that finished image — no build step on the host at all.

**One-time setup:** after the workflow's first run, the GHCR package
(`ghcr.io/andycqos74/soccercamp-app`) is created **private** by default, and a
private package needs credentials to pull. Either:
- Make it public (simplest): on GitHub, go to the package's page (from the
  repo's right-hand sidebar -> **Packages**, or
  `https://github.com/andycqos74?tab=packages`) -> **Package settings** ->
  **Change visibility** -> **Public**. Anonymous `docker pull` then works.
- Or keep it private and add credentials in Portainer: **Registries** ->
  **Add registry** -> **Custom registry**, URL `ghcr.io`, username your
  GitHub username, password a GitHub PAT with `read:packages` scope. Then
  select that registry when deploying the stack.

## Deploying (Portainer)

The MySQL container is `mysql-tickets`, on the `root_default` Docker network
— `docker-compose.yml` is already set to join that network and to publish
the app on host port **3010** (mapped to the container's internal port 3000).

1. **Create the stack.**
   Portainer -> **Stacks** -> **Add stack**.
   - *Name*: `soccercamp-app`.
   - *Build method*: "Repository" (point at this git repo, **Repository
     reference** `refs/heads/claude/soccer-camp-shirt-tracker-fgeu3e`,
     **Compose path** `soccercamp-app/docker-compose.yml`), or "Web editor"
     pasting the contents of `docker-compose.yml`. Either way, Portainer only
     reads the compose file here — it does **not** build anything, since the
     compose file references a pre-built `image:`, not `build:`.
   - If `mysql-tickets` is ever moved to a different network, update
     `networks.shared_net.name` in the compose file to match.

2. **Set environment variables.**
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

   The compose file references these as `${DB_HOST}` etc., which Portainer
   substitutes from the stack's environment variables at deploy time — no
   `.env` file needs to exist in the stack folder (a literal `env_file: .env`
   directive would require one, which is why that approach was dropped).

3. **Deploy the stack.** Portainer pulls `ghcr.io/andycqos74/soccercamp-app:latest`
   (see "Image build" above if this is the first deploy and the package is
   still private) and starts the container, joined to `root_default`. The
   `soccercamp_tickets` table is created automatically on first startup.

4. Browse to `http://<host>:3010/tickets`, or `/admin` to run the first
   sync from TicketCo.

**To pick up a new build later:** re-pull and recreate the stack in Portainer
(Stacks -> soccercamp-app -> **Update the stack**, or **Pull and redeploy**) —
`pull_policy: always` in the compose file makes it fetch the latest image
each time rather than reusing a cached one.

### Deploying from the CLI instead

```bash
cd soccercamp-app
cp .env.example .env   # fill in credentials and the API token
docker compose pull
docker compose up -d
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
