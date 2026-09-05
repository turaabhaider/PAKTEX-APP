const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

const PORT = 5000;

app.get('/', (req, res) => {
  res.json({
    message: 'Paktex API is running',
  });
});

app.listen(PORT, () => {
  console.log(`Paktex server running on port ${PORT}`);
});