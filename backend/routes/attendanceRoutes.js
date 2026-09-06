const express = require('express');

const authMiddleware = require('../middleware/authMiddleware');

const {
    checkIn,
    checkOut,
    getTodayAttendance,
    getMyAttendance,
} = require('../controllers/attendanceController');

const router = express.Router();

router.post(
    '/check-in',
    authMiddleware,
    checkIn
);

router.post(
    '/check-out',
    authMiddleware,
    checkOut
);

router.get(
    '/today',
    authMiddleware,
    getTodayAttendance
);

router.get(
    '/my',
    authMiddleware,
    getMyAttendance
);

module.exports = router;