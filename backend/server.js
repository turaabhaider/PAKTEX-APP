const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;

app.get('/', (req, res) => {
  res.json({
    message: 'Paktex API is running',
  });
});

app.get('/health', async (req, res) => {
  try {
    const db = require('./config/db');

    const [result] = await db.query('SELECT 1 AS connected');

    res.json({
      status: 'ok',
      server: 'healthy',
      database: 'connected',
      result: result[0],
    });
  } catch (error) {
    console.error('DATABASE ERROR:', error);

    res.status(500).json({
      status: 'error',
      server: 'healthy',
      database: 'disconnected',
      error: error.message || String(error),
      code: error.code || null,
    });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Paktex server running on port ${PORT}`);
});