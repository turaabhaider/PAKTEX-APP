const bcrypt = require('bcryptjs');
const db = require('../config/db');
const generateToken = require('../utils/generateToken');

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
    login,
};