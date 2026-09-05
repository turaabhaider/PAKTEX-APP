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

app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'Paktex backend is healthy',
  });
});

app.listen(PORT, () => {
  console.log(`Paktex server running on port ${PORT}`);
});