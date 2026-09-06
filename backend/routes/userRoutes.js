const express = require('express');

const authMiddleware = require('../middleware/authMiddleware');
const adminMiddleware = require('../middleware/adminMiddleware');

const {
    getUsers,
    getUser,
    createUser,
    updateUser,
    deleteUser,
} = require('../controllers/userController');

const router = express.Router();

router.get(
    '/',
    authMiddleware,
    getUsers
);

router.get(
    '/:id',
    authMiddleware,
    getUser
);

router.post(
    '/',
    authMiddleware,
    adminMiddleware,
    createUser
);

router.put(
    '/:id',
    authMiddleware,
    adminMiddleware,
    updateUser
);

router.delete(
    '/:id',
    authMiddleware,
    adminMiddleware,
    deleteUser
);

module.exports = router;