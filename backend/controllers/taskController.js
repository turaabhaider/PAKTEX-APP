const db = require('../config/db');

const ADMIN_EMAIL = 'zeekhi.work@gmail.com';

const isAdmin = (req) => {
    const email = String(req.user.email || '')
        .trim()
        .toLowerCase();

    const role = String(req.user.role || '')
        .trim()
        .toLowerCase();

    return email === ADMIN_EMAIL || role === 'admin';
};


// ===============================
// CREATE TASK
// ===============================

const createTask = async (req, res) => {
    try {
        // Only admins can create tasks
        if (!isAdmin(req)) {
            return res.status(403).json({
                message: 'Only admins can create tasks',
            });
        }

        const {
            title,
            description,
            assigned_to,
            due_date,
        } = req.body;

        if (!title || !assigned_to) {
            return res.status(400).json({
                message: 'Title and assigned user are required',
            });
        }

        // Check assigned user
        const [users] = await db.query(
            `
            SELECT
                id,
                email,
                role
            FROM users
            WHERE id = ?
            `,
            [assigned_to]
        );

        if (users.length === 0) {
            return res.status(404).json({
                message: 'Assigned user not found',
            });
        }

        const assignedUser = users[0];

        // Do not allow tasks to be assigned to admins
        const assignedEmail = String(
            assignedUser.email || ''
        )
            .trim()
            .toLowerCase();

        const assignedRole = String(
            assignedUser.role || ''
        )
            .trim()
            .toLowerCase();

        if (
            assignedEmail === ADMIN_EMAIL ||
            assignedRole === 'admin'
        ) {
            return res.status(400).json({
                message: 'Tasks can only be assigned to employees',
            });
        }

        // FIX: Added created_by to the INSERT query to resolve the database error
        const [result] = await db.query(
            `
            INSERT INTO tasks
                (
                    title,
                    description,
                    assigned_to,
                    assigned_by,
                    created_by,
                    due_date
                )
            VALUES
                (?, ?, ?, ?, ?, ?)
            `,
            [
                title,
                description || null,
                assigned_to,
                req.user.id,
                req.user.id,
                due_date || null,
            ]
        );

        return res.status(201).json({
            message: 'Task created successfully',
            taskId: result.insertId,
        });

    } catch (error) {
        console.error('CREATE TASK ERROR:', error);

        return res.status(500).json({
            message: 'Server error',
        });
    }
};


// ===============================
// GET TASKS
// ===============================

const getTasks = async (req, res) => {
    try {
        let query = `
            SELECT
                t.id,
                t.title,
                t.description,
                t.assigned_to,
                t.assigned_by,
                t.status,
                t.progress,
                t.due_date,
                t.created_at,
                t.updated_at,

                assigned.name AS assigned_to_name,
                creator.name AS assigned_by_name

            FROM tasks t

            JOIN users assigned
                ON t.assigned_to = assigned.id

            JOIN users creator
                ON t.assigned_by = creator.id
        `;

        const params = [];

        // Admin sees all employee tasks
        // Employee sees only their own tasks
        if (!isAdmin(req)) {
            query += `
                WHERE t.assigned_to = ?
            `;

            params.push(req.user.id);
        }

        query += `
            ORDER BY t.created_at DESC
        `;

        const [tasks] = await db.query(
            query,
            params
        );

        return res.status(200).json(tasks);

    } catch (error) {
        console.error('GET TASKS ERROR:', error);

        return res.status(500).json({
            message: 'Server error',
        });
    }
};


// ===============================
// GET SINGLE TASK
// ===============================

const getTask = async (req, res) => {
    try {
        const { id } = req.params;

        const [tasks] = await db.query(
            `
            SELECT
                t.*,
                assigned.name AS assigned_to_name,
                creator.name AS assigned_by_name

            FROM tasks t

            JOIN users assigned
                ON t.assigned_to = assigned.id

            JOIN users creator
                ON t.assigned_by = creator.id

            WHERE t.id = ?
            `,
            [id]
        );

        if (tasks.length === 0) {
            return res.status(404).json({
                message: 'Task not found',
            });
        }

        const task = tasks[0];

        // Employees can only open their own tasks
        if (
            !isAdmin(req) &&
            Number(task.assigned_to) !== Number(req.user.id)
        ) {
            return res.status(403).json({
                message: 'Access denied',
            });
        }

        return res.status(200).json(task);

    } catch (error) {
        console.error('GET TASK ERROR:', error);

        return res.status(500).json({
            message: 'Server error',
        });
    }
};


// ===============================
// UPDATE TASK
// ===============================

const updateTask = async (req, res) => {
    try {
        const { id } = req.params;

        const {
            title,
            description,
            status,
            progress,
            due_date,
        } = req.body;

        const [tasks] = await db.query(
            `
            SELECT *
            FROM tasks
            WHERE id = ?
            `,
            [id]
        );

        if (tasks.length === 0) {
            return res.status(404).json({
                message: 'Task not found',
            });
        }

        const task = tasks[0];

        // Employees can only update their own tasks
        if (
            !isAdmin(req) &&
            Number(task.assigned_to) !== Number(req.user.id)
        ) {
            return res.status(403).json({
                message: 'Access denied',
            });
        }

        let finalStatus =
            status || task.status;

        let finalProgress =
            progress !== undefined
                ? Number(progress)
                : task.progress;

        // Validate progress
        if (
            finalProgress < 0 ||
            finalProgress > 100
        ) {
            return res.status(400).json({
                message: 'Progress must be between 0 and 100',
            });
        }

        // Automatically update status
        if (finalProgress === 100) {
            finalStatus = 'completed';
        } else if (
            finalProgress > 0 &&
            finalStatus === 'pending'
        ) {
            finalStatus = 'in_progress';
        }

        await db.query(
            `
            UPDATE tasks

            SET
                title = ?,
                description = ?,
                status = ?,
                progress = ?,
                due_date = ?

            WHERE id = ?
            `,
            [
                title || task.title,
                description ?? task.description,
                finalStatus,
                finalProgress,
                due_date ?? task.due_date,
                id,
            ]
        );

        return res.status(200).json({
            message: 'Task updated successfully',
        });

    } catch (error) {
        console.error('UPDATE TASK ERROR:', error);

        return res.status(500).json({
            message: 'Server error',
        });
    }
};


// ===============================
// DELETE TASK
// ===============================

const deleteTask = async (req, res) => {
    try {
        // Only admins can delete tasks
        if (!isAdmin(req)) {
            return res.status(403).json({
                message: 'Only admins can delete tasks',
            });
        }

        const { id } = req.params;

        const [result] = await db.query(
            `
            DELETE FROM tasks
            WHERE id = ?
            `,
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                message: 'Task not found',
            });
        }

        return res.status(200).json({
            message: 'Task deleted successfully',
        });

    } catch (error) {
        console.error('DELETE TASK ERROR:', error);

        return res.status(500).json({
            message: 'Server error',
        });
    }
};


module.exports = {
    createTask,
    getTasks,
    getTask,
    updateTask,
    deleteTask,
};