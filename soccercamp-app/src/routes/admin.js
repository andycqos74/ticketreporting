const express = require('express');
const { syncSoccerCampTickets, SEASON_PASS_ID, TICKET_TYPE_FILTER } = require('../ticketco');

const router = express.Router();

router.get('/', (req, res) => {
  res.render('admin', {
    seasonPassId: SEASON_PASS_ID,
    ticketTypeFilter: TICKET_TYPE_FILTER,
    result: null,
    sample: null,
    error: null,
  });
});

router.post('/sync', async (req, res) => {
  try {
    const { matched, sample } = await syncSoccerCampTickets();
    res.render('admin', {
      seasonPassId: SEASON_PASS_ID,
      ticketTypeFilter: TICKET_TYPE_FILTER,
      result: `Sync complete at ${new Date().toLocaleTimeString('en-GB')}: ${matched} ticket(s) matched "${TICKET_TYPE_FILTER}".`,
      sample,
      error: null,
    });
  } catch (err) {
    res.render('admin', {
      seasonPassId: SEASON_PASS_ID,
      ticketTypeFilter: TICKET_TYPE_FILTER,
      result: null,
      sample: null,
      error: `Sync failed: ${err.message}`,
    });
  }
});

module.exports = router;
