const db = require('../config/db');

const checkIn = async (req, res) => {
    try {
        const userId = req.user.id;

        const [existing] = await db.query(
            `SELECT id, check_in, check_out
             FROM attendance
             WHERE user_id = ? AND date = CURDATE()`,
            [userId]
        );

        if (existing.length > 0) {
            return res.status(400).json({
                message: 'Already checked in today',
                attendance: existing[0],
            });
        }

        const [result] = await db.query(
            `INSERT INTO attendance
             (user_id, check_in, date)
             VALUES (?, NOW(), CURDATE())`,
            [userId]
        );

        res.status(201).json({
            message: 'Check-in successful',
            attendanceId: result.insertId,
        });
    } catch (error) {
        console.error('CHECK-IN ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const checkOut = async (req, res) => {
    try {
        const userId = req.user.id;

        const [attendance] = await db.query(
            `SELECT *
             FROM attendance
             WHERE user_id = ? AND date = CURDATE()
             LIMIT 1`,
            [userId]
        );

        if (attendance.length === 0) {
            return res.status(400).json({
                message: 'You have not checked in today',
            });
        }

        if (attendance[0].check_out) {
            return res.status(400).json({
                message: 'Already checked out today',
            });
        }

        await db.query(
            `UPDATE attendance
             SET check_out = NOW()
             WHERE id = ?`,
            [attendance[0].id]
        );

        res.json({
            message: 'Check-out successful',
        });
    } catch (error) {
        console.error('CHECK-OUT ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const getTodayAttendance = async (req, res) => {
    try {
        const [attendance] = await db.query(
            `SELECT
                a.id,
                a.user_id,
                u.name,
                u.position,
                a.check_in,
                a.check_out,
                a.date
             FROM attendance a
             JOIN users u ON a.user_id = u.id
             WHERE a.date = CURDATE()
             ORDER BY a.check_in ASC`
        );

        res.json(attendance);
    } catch (error) {
        console.error('TODAY ATTENDANCE ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const getMyAttendance = async (req, res) => {
    try {
        const [attendance] = await db.query(
            `SELECT *
             FROM attendance
             WHERE user_id = ?
             ORDER BY date DESC`,
            [req.user.id]
        );

        res.json(attendance);
    } catch (error) {
        console.error('MY ATTENDANCE ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

module.exports = {
    checkIn,
    checkOut,
    getTodayAttendance,
    getMyAttendance,
};