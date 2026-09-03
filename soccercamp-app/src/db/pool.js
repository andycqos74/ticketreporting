const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'mysql',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME || 'qosfctickets',
  waitForConnections: true,
  connectionLimit: 10,
});

async function ensureSchema() {
  const schema = fs.readFileSync(path.join(__dirname, '..', '..', 'schema.sql'), 'utf8')
    .split('\n')
    .map((line) => line.replace(/--.*$/, ''))
    .join('\n');
  const statements = schema
    .split(';')
    .map((s) => s.trim())
    .filter((s) => s.length > 0);
  for (const statement of statements) {
    await pool.query(statement);
  }

  // CREATE TABLE IF NOT EXISTS above only helps on a fresh install - on an
  // existing table it's a no-op, so a column/index added to schema.sql later
  // needs to be migrated in here explicitly.
  await ensureColumn('soccercamp_tickets', 'Email', 'VARCHAR(255) NULL AFTER BuyerLastName');
  await ensureIndex('soccercamp_tickets', 'idx_email', 'Email');
}

async function ensureColumn(table, column, definition) {
  const [rows] = await pool.query(
    `SELECT COUNT(*) AS cnt FROM information_schema.columns
     WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ?`,
    [table, column]
  );
  if (rows[0].cnt === 0) {
    await pool.query(`ALTER TABLE ${table} ADD COLUMN ${column} ${definition}`);
  }
}

async function ensureIndex(table, indexName, columns) {
  const [rows] = await pool.query(
    `SELECT COUNT(*) AS cnt FROM information_schema.statistics
     WHERE table_schema = DATABASE() AND table_name = ? AND index_name = ?`,
    [table, indexName]
  );
  if (rows[0].cnt === 0) {
    await pool.query(`ALTER TABLE ${table} ADD INDEX ${indexName} (${columns})`);
  }
}

module.exports = { pool, ensureSchema };
