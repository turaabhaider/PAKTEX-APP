const mysql = require('mysql2/promise');

console.log('MYSQL_URL exists:', !!process.env.MYSQL_URL);

const pool = mysql.createPool(process.env.MYSQL_URL);

module.exports = pool;