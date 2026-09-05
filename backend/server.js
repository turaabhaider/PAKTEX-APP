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

    await db.query('SELECT 1');

    res.json({
      status: 'ok',
      server: 'healthy',
      database: 'connected',
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      server: 'healthy',
      database: 'disconnected',
      error: error.message,
    });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Paktex server running on port ${PORT}`);
});