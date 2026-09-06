const bcrypt = require('bcryptjs');
const db = require('../config/db');

const getUsers = async (req, res) => {
    try {
        const [users] = await db.query(
            `SELECT id, name, email, role, position, created_at
             FROM users
             ORDER BY name ASC`
        );

        res.json(users);
    } catch (error) {
        console.error('GET USERS ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const getUser = async (req, res) => {
    try {
        const { id } = req.params;

        const [users] = await db.query(
            `SELECT id, name, email, role, position, created_at
             FROM users
             WHERE id = ?`,
            [id]
        );

        if (users.length === 0) {
            return res.status(404).json({
                message: 'User not found',
            });
        }

        res.json(users[0]);
    } catch (error) {
        console.error('GET USER ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const createUser = async (req, res) => {
    try {
        const {
            name,
            email,
            password,
            role = 'employee',
            position,
        } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({
                message: 'Name, email and password are required',
            });
        }

        if (!['admin', 'employee'].includes(role)) {
            return res.status(400).json({
                message: 'Invalid role',
            });
        }

        const hashedPassword = await bcrypt.hash(password, 12);

        // Column is `password_hash`, matching register()/login() in
        // authController.js. Previously this inserted into a `password`
        // column, which login() never reads — any user created here
        // would never be able to log in.
        const [result] = await db.query(
            `INSERT INTO users
             (name, email, password_hash, role, position)
             VALUES (?, ?, ?, ?, ?)`,
            [
                name,
                email,
                hashedPassword,
                role,
                position || null,
            ]
        );

        res.status(201).json({
            message: 'User created successfully',
            userId: result.insertId,
        });
    } catch (error) {
        console.error('CREATE USER ERROR:', error);

        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({
                message: 'Email already exists',
            });
        }

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { name, email, role, position } = req.body;

        const [result] = await db.query(
            `UPDATE users
             SET name = ?, email = ?, role = ?, position = ?
             WHERE id = ?`,
            [
                name,
                email,
                role,
                position || null,
                id,
            ]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                message: 'User not found',
            });
        }

        res.json({
            message: 'User updated successfully',
        });
    } catch (error) {
        console.error('UPDATE USER ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;

        if (Number(id) === req.user.id) {
            return res.status(400).json({
                message: 'You cannot delete yourself',
            });
        }

        const [result] = await db.query(
            'DELETE FROM users WHERE id = ?',
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                message: 'User not found',
            });
        }

        res.json({
            message: 'User deleted successfully',
        });
    } catch (error) {
        console.error('DELETE USER ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

module.exports = {
    getUsers,
    getUser,
    createUser,
    updateUser,
    deleteUser,
};