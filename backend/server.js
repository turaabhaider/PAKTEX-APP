const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const attendanceRoutes = require('./routes/attendanceRoutes');
const taskRoutes = require('./routes/taskRoutes');

const db = require('./config/db');

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;

app.get('/', (req, res) => {
    res.json({ message: 'Paktex API is running' });
});

app.get('/health', async (req, res) => {
    try {
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
        });
    }
});

app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/attendance', attendanceRoutes);
app.use('/api/tasks', taskRoutes);

app.use((req, res) => {
    res.status(404).json({ message: 'Route not found' });
});

async function updateDatabase() {
    try {
        // 1. Ensure password column in users
        const [userCols] = await db.query(
            `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'password'`
        );
        if (userCols.length === 0) {
            await db.query(`ALTER TABLE users ADD COLUMN password VARCHAR(255) NULL`);
            console.log('password column added.');
        }

        // 2. Ensure assigned_by column in tasks
        const [assignedByCols] = await db.query(
            `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tasks' AND COLUMN_NAME = 'assigned_by'`
        );
        if (assignedByCols.length === 0) {
            await db.query(`ALTER TABLE tasks ADD COLUMN assigned_by INT NULL`);
            console.log('assigned_by column added.');
        }

        // 3. Ensure progress column in tasks
        const [progressCols] = await db.query(
            `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tasks' AND COLUMN_NAME = 'progress'`
        );
        if (progressCols.length === 0) {
            await db.query(`ALTER TABLE tasks ADD COLUMN progress INT DEFAULT 0`);
            console.log('progress column added.');
        }

        // 4. Modify created_by to accept NULL values
        const [createdByCols] = await db.query(
            `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tasks' AND COLUMN_NAME = 'created_by'`
        );
        if (createdByCols.length > 0) {
            await db.query(`ALTER TABLE tasks MODIFY COLUMN created_by INT NULL`);
            console.log('created_by column modified to allow NULL.');
        }

        // 5. Update admin role
        await db.query(`UPDATE users SET role = 'admin' WHERE email = ?`, ['zeekhi.work@gmail.com']);
        console.log('Admin role updated successfully.');
    } catch (error) {
        console.error('DATABASE MIGRATION ERROR:', error);
    }
}

async function startServer() {
    await updateDatabase();
    app.listen(PORT, '0.0.0.0', () => {
        console.log(`Paktex server running on port ${PORT}`);
    });
}

startServer();