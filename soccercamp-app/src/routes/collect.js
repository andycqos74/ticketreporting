const express = require('express');
const { pool } = require('../db/pool');

const router = express.Router();

const SHIRT_SIZES = ['5XS', '4XS', '3XS', 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL'];

async function findTicket(id) {
  if (!id) return null;
  const [rows] = await pool.query(
    `SELECT TicketID, TicketCoRef, TicketType, EventName, PurchaseDate, Email,
            TRIM(CONCAT(HolderFirstName, ' ', HolderLastName)) AS PrintName,
            Collected, ShirtSize, CollectedDate, CollectedBy
     FROM soccercamp_tickets
     WHERE TicketID = ? OR TicketCoRef = ?
     LIMIT 1`,
    [id, id]
  );
  return rows[0] || null;
}

// Other tickets bought under the same email address (any number of them -
// families sometimes have more than two kids on the camp), so they can all
// be marked collected from the one scan without hunting down each ticket.
async function findLinkedTickets(ticket) {
  if (!ticket || !ticket.Email) return [];
  const [rows] = await pool.query(
    `SELECT TicketID, TicketCoRef, TicketType, EventName, PurchaseDate, Email,
            TRIM(CONCAT(HolderFirstName, ' ', HolderLastName)) AS PrintName,
            Collected, ShirtSize, CollectedDate, CollectedBy
     FROM soccercamp_tickets
     WHERE Email = ? AND TicketID <> ?
     ORDER BY HolderFirstName, HolderLastName`,
    [ticket.Email, ticket.TicketID]
  );
  return rows;
}

router.get('/', async (req, res, next) => {
  try {
    const id = (req.query.id || '').trim();
    const ticket = id ? await findTicket(id) : null;
    res.render('collect', {
      id,
      ticket,
      linkedTickets: await findLinkedTickets(ticket),
      shirtSizes: SHIRT_SIZES,
      notFound: id && !ticket,
      message: null,
      error: null,
    });
  } catch (err) {
    next(err);
  }
});

// Used by the QR-scan JS to look up a scanned code without a full page reload.
router.get('/lookup', async (req, res, next) => {
  try {
    const id = (req.query.id || '').trim();
    const ticket = await findTicket(id);
    if (!ticket) return res.status(404).json({ found: false });
    res.json({ found: true, ticket, linkedTickets: await findLinkedTickets(ticket) });
  } catch (err) {
    next(err);
  }
});

router.post('/mark', async (req, res, next) => {
  try {
    const { id, shirtSize, collectedBy, override } = req.body;
    const ticket = await findTicket(id);

    if (!ticket) {
      return res.render('collect', {
        id, ticket: null, linkedTickets: [], shirtSizes: SHIRT_SIZES, notFound: true, message: null,
        error: 'Ticket not found.',
      });
    }

    if (ticket.Collected && !override) {
      return res.render('collect', {
        id, ticket, linkedTickets: await findLinkedTickets(ticket), shirtSizes: SHIRT_SIZES, notFound: false, message: null,
        error: `Already collected on ${new Date(ticket.CollectedDate).toLocaleString('en-GB')} (size ${ticket.ShirtSize}). Tick "Override" to change it.`,
      });
    }

    if (!shirtSize) {
      return res.render('collect', {
        id, ticket, linkedTickets: await findLinkedTickets(ticket), shirtSizes: SHIRT_SIZES, notFound: false, message: null,
        error: 'Please choose a shirt size.',
      });
    }

    await pool.execute(
      `UPDATE soccercamp_tickets
       SET Collected = 1, CollectedDate = NOW(), ShirtSize = ?, CollectedBy = ?
       WHERE TicketID = ?`,
      [shirtSize, (collectedBy || '').trim() || null, ticket.TicketID]
    );

    const updated = await findTicket(id);
    res.render('collect', {
      id, ticket: updated, linkedTickets: await findLinkedTickets(updated), shirtSizes: SHIRT_SIZES, notFound: false,
      message: `Shirt (${shirtSize}) marked collected for ${updated.PrintName}.`,
      error: null,
    });
  } catch (err) {
    next(err);
  }
});

// Undoes a mistaken collection (shirt issued against the wrong ticket) so it
// can be corrected against the right one. Clears Collected/size/date/by but
// leaves the ticket record itself in place.
router.post('/uncollect', async (req, res, next) => {
  try {
    const { id } = req.body;
    const ticket = await findTicket(id);

    if (!ticket) {
      return res.render('collect', {
        id, ticket: null, linkedTickets: [], shirtSizes: SHIRT_SIZES, notFound: true, message: null,
        error: 'Ticket not found.',
      });
    }

    await pool.execute(
      `UPDATE soccercamp_tickets
       SET Collected = 0, CollectedDate = NULL, ShirtSize = NULL, CollectedBy = NULL
       WHERE TicketID = ?`,
      [ticket.TicketID]
    );

    const updated = await findTicket(id);
    res.render('collect', {
      id, ticket: updated, linkedTickets: await findLinkedTickets(updated), shirtSizes: SHIRT_SIZES, notFound: false,
      message: `Collection removed for ${updated.PrintName} - it can now be collected again.`,
      error: null,
    });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
