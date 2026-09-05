const mysql = require('mysql2/promise');

console.log('MYSQL_URL exists:', !!process.env.MYSQL_URL);

if (process.env.MYSQL_URL) {
  const dbUrl = new URL(process.env.MYSQL_URL);

  console.log('MYSQL_HOST:', dbUrl.hostname);
  console.log('MYSQL_PORT:', dbUrl.port);
}

const pool = mysql.createPool(process.env.MYSQL_URL);

module.exports = pool;