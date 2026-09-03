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
}

module.exports = { pool, ensureSchema };
