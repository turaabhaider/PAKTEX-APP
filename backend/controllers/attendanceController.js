const db = require('../config/db');

const checkIn = async (req, res) => {
    try {
        const userId = req.user.id;

        const [existing] = await db.query(
            `
            SELECT
                id,
                user_id,
                check_in,
                check_out,
                date
            FROM attendance
            WHERE user_id = ?
              AND date = CURDATE()
            LIMIT 1
            `,
            [userId]
        );

        if (existing.length > 0) {
            return res.status(400).json({
                message: 'Already checked in today',
                attendance: existing[0],
            });
        }

        const [result] = await db.query(
            `
            INSERT INTO attendance
                (user_id, check_in, date)
            VALUES
                (?, NOW(), CURDATE())
            `,
            [userId]
        );

        return res.status(201).json({
            message: 'Check-in successful',
            attendanceId: result.insertId,
        });
    } catch (error) {
        console.error('CHECK-IN ERROR:', error);

        return res.status(500).json({
            message: 'Attendance check-in server error',
            error: error.message,
        });
    }
};

const checkOut = async (req, res) => {
    try {
        const userId = req.user.id;

        const [attendance] = await db.query(
            `
            SELECT
                id,
                user_id,
                check_in,
                check_out,
                date
            FROM attendance
            WHERE user_id = ?
              AND date = CURDATE()
            LIMIT 1
            `,
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
            `
            UPDATE attendance
            SET check_out = NOW()
            WHERE id = ?
            `,
            [attendance[0].id]
        );

        return res.status(200).json({
            message: 'Check-out successful',
        });
    } catch (error) {
        console.error('CHECK-OUT ERROR:', error);

        return res.status(500).json({
            message: 'Attendance check-out server error',
            error: error.message,
        });
    }
};

const getTodayAttendance = async (req, res) => {
    try {
        const [attendance] = await db.query(
            `
            SELECT
                a.id,
                a.user_id,
                u.name,
                u.email,
                u.position,
                u.role,
                a.check_in,
                a.check_out,
                a.date
            FROM attendance a
            INNER JOIN users u
                ON a.user_id = u.id
            WHERE a.date = CURDATE()
            ORDER BY a.check_in ASC
            `
        );

        return res.status(200).json(attendance);
    } catch (error) {
        console.error('TODAY ATTENDANCE ERROR:', error);

        return res.status(500).json({
            message: 'Today attendance server error',
            error: error.message,
        });
    }
};

const getMyAttendance = async (req, res) => {
    try {
        const userId = req.user.id;

        const [attendance] = await db.query(
            `
            SELECT
                id,
                user_id,
                check_in,
                check_out,
                date
            FROM attendance
            WHERE user_id = ?
            ORDER BY date DESC
            `,
            [userId]
        );

        return res.status(200).json(attendance);
    } catch (error) {
        console.error('MY ATTENDANCE ERROR:', error);

        return res.status(500).json({
            message: 'My attendance server error',
            error: error.message,
        });
    }
};

module.exports = {
    checkIn,
    checkOut,
    getTodayAttendance,
    getMyAttendance,
};