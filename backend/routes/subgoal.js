const router = require('express').Router();
const sql = require('mssql');
const verifyJWT = require('../middlewares/midauthen');
require('dotenv').config();

const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    options: {
        encrypt: true,
        enableArithAbort: true
    }
};

router.get('/all', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query('SELECT * FROM Subgoals WHERE user_id = @user_id');
        res.json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/all/:goal_id}', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const { goal_id } = req.params;
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('goal_id', sql.Int, goal_id)
            .query('SELECT * FROM Subgoals WHERE user_id = @user_id AND goal_id = @goal_id');
        res.json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.post('/create/:goal_id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const { goal_id } = req.params;
    const { subgoalName } = req.body;
    console.log('first')
    if (!user_id || !goal_id || !subgoalName) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('goal_id', sql.Int, goal_id)
            .input('user_id', sql.Int, user_id)
            .input('subgoalName', sql.NVarChar, subgoalName)
            .query('INSERT INTO Subgoals (goal_id, user_id, subgoalName) VALUES (@goal_id, @user_id, @subgoalName)');
        res.status(201).send('Created');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.delete('/delete/:subgoal_id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const { subgoal_id } = req.params;
    if (!user_id || !subgoal_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('subgoal_id', sql.Int, subgoal_id)
            .query('DELETE FROM Subgoals WHERE user_id = @user_id AND subgoal_id = @subgoal_id');
        res.status(200).send('Deleted');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.patch('/update/:subgoal_id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const { subgoal_id } = req.params;
    const { subgoalName } = req.body;
    if (!user_id || !subgoal_id || !subgoalName) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('subgoal_id', sql.Int, subgoal_id)
            .input('subgoalName', sql.NVarChar, subgoalName)
            .query('UPDATE Subgoals SET subgoalName = @subgoalName WHERE user_id = @user_id AND subgoal_id = @subgoal_id');
        res.status(200).send('Updated');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

module.exports = router;