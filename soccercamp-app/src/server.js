require('dotenv').config();
const path = require('path');
const express = require('express');
const { ensureSchema } = require('./db/pool');

const adminRoutes = require('./routes/admin');
const listRoutes = require('./routes/list');
const collectRoutes = require('./routes/collect');

const app = express();
const PORT = process.env.PORT || 3000;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '..', 'views'));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, '..', 'public')));

app.get('/', (req, res) => res.redirect('/tickets'));
app.use('/admin', adminRoutes);
app.use('/tickets', listRoutes);
app.use('/collect', collectRoutes);

ensureSchema()
  .then(() => {
    app.listen(PORT, () => console.log(`Soccer Camps app listening on port ${PORT}`));
  })
  .catch((err) => {
    console.error('Failed to prepare database schema:', err);
    process.exit(1);
  });
