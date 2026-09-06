const db = require('../config/db');

const createTask = async (req, res) => {
    try {
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

        const [users] = await db.query(
            'SELECT id FROM users WHERE id = ?',
            [assigned_to]
        );

        if (users.length === 0) {
            return res.status(404).json({
                message: 'Assigned user not found',
            });
        }

        const [result] = await db.query(
            `INSERT INTO tasks
             (title, description, assigned_to, assigned_by, due_date)
             VALUES (?, ?, ?, ?, ?)`,
            [
                title,
                description || null,
                assigned_to,
                req.user.id,
                due_date || null,
            ]
        );

        res.status(201).json({
            message: 'Task created successfully',
            taskId: result.insertId,
        });
    } catch (error) {
        console.error('CREATE TASK ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

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

        if (req.user.role !== 'admin') {
            query += ' WHERE t.assigned_to = ?';
            params.push(req.user.id);
        }

        query += ' ORDER BY t.created_at DESC';

        const [tasks] = await db.query(query, params);

        res.json(tasks);
    } catch (error) {
        console.error('GET TASKS ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const getTask = async (req, res) => {
    try {
        const { id } = req.params;

        const [tasks] = await db.query(
            `SELECT
                t.*,
                assigned.name AS assigned_to_name,
                creator.name AS assigned_by_name
             FROM tasks t
             JOIN users assigned
                ON t.assigned_to = assigned.id
             JOIN users creator
                ON t.assigned_by = creator.id
             WHERE t.id = ?`,
            [id]
        );

        if (tasks.length === 0) {
            return res.status(404).json({
                message: 'Task not found',
            });
        }

        const task = tasks[0];

        if (
            req.user.role !== 'admin' &&
            task.assigned_to !== req.user.id
        ) {
            return res.status(403).json({
                message: 'Access denied',
            });
        }

        res.json(task);
    } catch (error) {
        console.error('GET TASK ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

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
            'SELECT * FROM tasks WHERE id = ?',
            [id]
        );

        if (tasks.length === 0) {
            return res.status(404).json({
                message: 'Task not found',
            });
        }

        const task = tasks[0];

        if (
            req.user.role !== 'admin' &&
            task.assigned_to !== req.user.id
        ) {
            return res.status(403).json({
                message: 'Access denied',
            });
        }

        let finalStatus = status || task.status;
        let finalProgress =
            progress !== undefined
                ? Number(progress)
                : task.progress;

        if (finalProgress < 0 || finalProgress > 100) {
            return res.status(400).json({
                message: 'Progress must be between 0 and 100',
            });
        }

        if (finalProgress === 100) {
            finalStatus = 'completed';
        } else if (
            finalProgress > 0 &&
            finalStatus === 'pending'
        ) {
            finalStatus = 'in_progress';
        }

        await db.query(
            `UPDATE tasks
             SET title = ?,
                 description = ?,
                 status = ?,
                 progress = ?,
                 due_date = ?
             WHERE id = ?`,
            [
                title || task.title,
                description ?? task.description,
                finalStatus,
                finalProgress,
                due_date ?? task.due_date,
                id,
            ]
        );

        res.json({
            message: 'Task updated successfully',
        });
    } catch (error) {
        console.error('UPDATE TASK ERROR:', error);

        res.status(500).json({
            message: 'Server error',
        });
    }
};

const deleteTask = async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.query(
            'DELETE FROM tasks WHERE id = ?',
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                message: 'Task not found',
            });
        }

        res.json({
            message: 'Task deleted successfully',
        });
    } catch (error) {
        console.error('DELETE TASK ERROR:', error);

        res.status(500).json({
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