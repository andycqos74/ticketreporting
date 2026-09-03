const express = require('express');
const { pool } = require('../db/pool');

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    const filter = req.query.filter || 'all';
    const search = (req.query.search || '').trim();

    let sql = `
      SELECT TicketID, TicketCoRef, TicketType, PurchaseDate, Email,
             TRIM(CONCAT(HolderFirstName, ' ', HolderLastName)) AS PrintName,
             Collected, ShirtSize, CollectedDate
      FROM soccercamp_tickets
      WHERE 1=1
    `;
    const params = [];

    if (filter === 'collected') sql += ' AND Collected = 1';
    if (filter === 'notcollected') sql += ' AND Collected = 0';

    if (search) {
      sql += ' AND (HolderFirstName LIKE ? OR HolderLastName LIKE ? OR TicketCoRef LIKE ?)';
      const like = `%${search}%`;
      params.push(like, like, like);
    }

    sql += ' ORDER BY HolderLastName, HolderFirstName';

    const [rows] = await pool.query(sql, params);
    res.render('list', { rows, filter, search });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
