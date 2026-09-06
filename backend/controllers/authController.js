const bcrypt = require('bcryptjs');
const db = require('../config/db');
const generateToken = require('../utils/generateToken');

const register = async (req, res) => {
    try {
        const { name, email, password, position } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({
                message: 'Name, email and password are required',
            });
        }

        const [existingUsers] = await db.query(
            'SELECT id FROM users WHERE email = ? LIMIT 1',
            [email]
        );

        if (existingUsers.length > 0) {
            return res.status(409).json({
                message: 'Email already exists',
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const [result] = await db.query(
            `INSERT INTO users
            (name, email, password, role, position)
            VALUES (?, ?, ?, ?, ?)`,
            [
                name,
                email,
                hashedPassword,
                'employee',
                position || 'Employee',
            ]
        );

        res.status(201).json({
            message: 'Account created successfully',
            user: {
                id: result.insertId,
                name,
                email,
                role: 'employee',
                position: position || 'Employee',
            },
        });
    } catch (error) {
        console.error('REGISTER ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                message: 'Email and password are required',
            });
        }

        const [users] = await db.query(
            'SELECT * FROM users WHERE email = ? LIMIT 1',
            [email]
        );

        if (users.length === 0) {
            return res.status(401).json({
                message: 'Invalid email or password',
            });
        }

        const user = users[0];

        const passwordMatch = await bcrypt.compare(
            password,
            user.password
        );

        if (!passwordMatch) {
            return res.status(401).json({
                message: 'Invalid email or password',
            });
        }

        const token = generateToken(user);

        res.json({
            message: 'Login successful',
            token,
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
                position: user.position,
            },
        });
    } catch (error) {
        console.error('LOGIN ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

module.exports = {
    register,
    login,
};