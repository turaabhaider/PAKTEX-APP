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
    res.json({
        message: 'Paktex API is running',
    });
});

app.get('/health', async (req, res) => {
    try {
        const [result] = await db.query(
            'SELECT 1 AS connected'
        );

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

app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/attendance', attendanceRoutes);
app.use('/api/tasks', taskRoutes);

app.use((req, res) => {
    res.status(404).json({
        message: 'Route not found',
    });
});

async function updateDatabase() {
    try {
        // 1. Ensure password column exists in users table
        const [userColumns] = await db.query(
            `
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = 'users'
            AND COLUMN_NAME = 'password'
            `
        );

        if (userColumns.length === 0) {
            console.log('password column missing in users. Adding it...');
            await db.query(`ALTER TABLE users ADD COLUMN password VARCHAR(255) NULL`);
            console.log('password column added successfully.');
        } else {
            console.log('password column already exists.');
        }

        // 2. Ensure assigned_by column exists in tasks table
        const [taskColumns] = await db.query(
            `
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = 'tasks'
            AND COLUMN_NAME = 'assigned_by'
            `
        );

        if (taskColumns.length === 0) {
            console.log('assigned_by column missing in tasks. Adding it...');
            await db.query(`ALTER TABLE tasks ADD COLUMN assigned_by INT NULL`);
            console.log('assigned_by column added successfully.');
        } else {
            console.log('assigned_by column already exists.');
        }

        // 3. Set zeekhi.work@gmail.com as admin on startup
        const [result] = await db.query(
            `UPDATE users SET role = 'admin' WHERE email = ?`,
            ['zeekhi.work@gmail.com']
        );
        console.log(`Admin role updated successfully. Rows affected: ${result.affectedRows}`);

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