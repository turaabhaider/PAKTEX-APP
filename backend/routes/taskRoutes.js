const express = require('express');

const authMiddleware = require('../middleware/authMiddleware');
const adminMiddleware = require('../middleware/adminMiddleware');

const {
    createTask,
    getTasks,
    getTask,
    updateTask,
    deleteTask,
} = require('../controllers/taskController');

const router = express.Router();

router.get(
    '/',
    authMiddleware,
    getTasks
);

router.get(
    '/:id',
    authMiddleware,
    getTask
);

router.post(
    '/',
    authMiddleware,
    adminMiddleware,
    createTask
);

router.put(
    '/:id',
    authMiddleware,
    updateTask
);

router.delete(
    '/:id',
    authMiddleware,
    adminMiddleware,
    deleteTask
);

module.exports = router;