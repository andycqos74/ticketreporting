const { pool } = require('./db/pool');

const API_BASE = 'https://ticketco.events/api/public/v1/item_grosses';
const SEASON_PASS_ID = process.env.SEASON_PASS_ID || '1127619';
const TICKET_TYPE_FILTER = process.env.TICKET_TYPE_FILTER || 'Soccer Camps 2026';

function str(item, key) {
  const v = item[key];
  return v === null || v === undefined ? '' : String(v);
}

// TicketCo returns timestamps as ISO 8601 with a timezone offset (e.g.
// "2026-07-16T14:01:42+00:00"), which MySQL's DATETIME rejects outright -
// it wants "YYYY-MM-DD HH:MM:SS". Convert to that, in UTC.
function toMysqlDatetime(v) {
  if (!v) return null;
  const d = new Date(v);
  if (Number.isNaN(d.getTime())) return null;
  return d.toISOString().slice(0, 19).replace('T', ' ');
}

async function fetchPage(token, page) {
  const url = `${API_BASE}?token=${encodeURIComponent(token)}&event_id=${encodeURIComponent(SEASON_PASS_ID)}&page=${page}`;
  const res = await fetch(url, { headers: { 'User-Agent': 'SoccerCamps-App/1.0' } });
  if (!res.ok) {
    throw new Error(`TicketCo API returned HTTP ${res.status} on page ${page}`);
  }
  const body = await res.json();
  return Array.isArray(body.item_grosses) ? body.item_grosses : [];
}

const UPSERT_SQL = `
  INSERT INTO soccercamp_tickets
    (TicketID, TicketCoRef, PurchaseDate, TicketType, EventName,
     HolderFirstName, HolderLastName, BuyerFirstName, BuyerLastName)
  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  ON DUPLICATE KEY UPDATE
    TicketCoRef = VALUES(TicketCoRef),
    PurchaseDate = VALUES(PurchaseDate),
    TicketType = VALUES(TicketType),
    EventName = VALUES(EventName),
    HolderFirstName = VALUES(HolderFirstName),
    HolderLastName = VALUES(HolderLastName),
    BuyerFirstName = VALUES(BuyerFirstName),
    BuyerLastName = VALUES(BuyerLastName)
`;

// Pulls every page of item_grosses for the soccer camps season pass, keeps
// only rows matching TICKET_TYPE_FILTER, and upserts them. Collected status
// and shirt size are never touched by a sync.
async function syncSoccerCampTickets() {
  const token = process.env.TICKETCO_API_TOKEN;
  if (!token) {
    throw new Error('Missing TICKETCO_API_TOKEN environment variable');
  }

  let page = 1;
  let matched = 0;

  for (;;) {
    const items = await fetchPage(token, page);
    if (items.length === 0) break;

    for (const item of items) {
      const ticketType = str(item, 'item_type_title').trim();
      if (ticketType.toLowerCase() !== TICKET_TYPE_FILTER.toLowerCase()) continue;

      const uuid = str(item, 'uuid');
      if (!uuid) continue; // no stable key to upsert on

      await pool.execute(UPSERT_SQL, [
        uuid,
        str(item, 'ref_number'),
        toMysqlDatetime(str(item, 'transaction_datestamp')),
        str(item, 'item_type_title'),
        str(item, 'event_name'),
        str(item, 'holder_first_name'),
        str(item, 'holder_last_name'),
        str(item, 'buyer_first_name'),
        str(item, 'buyer_last_name'),
      ]);
      matched += 1;
    }

    page += 1;
  }

  return matched;
}

module.exports = { syncSoccerCampTickets, SEASON_PASS_ID, TICKET_TYPE_FILTER };
