const router = require('express').Router();
const sql = require('mssql');
const moment = require('moment-timezone');
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

function getCurrentDateTimeUTC7() {
    const dateTime = moment();
    const dateTimeUTC7 = dateTime.tz('Asia/Bangkok');
    return dateTimeUTC7.format('YYYY-MM-DDTHH:mm:ss.SSS') + 'Z';
}

router.post('/create', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const { goal_name, deadline, subgoals } = req.body;
    const progress = 0;
    const created_at = getCurrentDateTimeUTC7();
    const updated_at = created_at;

    if (!user_id || !goal_name || !deadline || !subgoals) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const transaction = new sql.Transaction(pool);
        await transaction.begin();
        const createGoal = await transaction.request()
            .input('user_id', sql.Int, user_id)
            .input('goal_name', sql.NVarChar, goal_name)
            .input('deadline', sql.Date, deadline)
            .input('progress', sql.Int, progress)
            .input('created_at', sql.DateTime, created_at)
            .input('updated_at', sql.DateTime, updated_at)
            .query('INSERT INTO Goals (user_id, goal_name, deadline, progress, created_at, updated_at) VALUES (@user_id, @goal_name, @deadline, @progress, @created_at, @updated_at); SELECT SCOPE_IDENTITY() AS goal_id');
        const goal_id = createGoal.recordset[0].goal_id;
        for (const subgoal of subgoals) {
            await transaction.request()
                .input('goal_id', sql.Int, goal_id)
                .input('user_id', sql.Int, user_id)
                .input('subgoalName', sql.NVarChar, subgoal)
                .query('INSERT INTO Subgoals (goal_id,  user_id, subgoalName) VALUES (@goal_id, @user_id, @subgoalName)');
        }
        await transaction.commit();
        res.status(201).json({ goal_id });
        //res.status(201).send(transaction);

    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }

});

router.get('/getGoals', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    if (!user_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query('SELECT * FROM Goals WHERE user_id = @user_id');
        res.json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/getGoal/:goal_id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const goal_id = req.params.goal_id;
    if (!user_id || !goal_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('goal_id', sql.Int, goal_id)
            .query('SELECT * FROM Goals WHERE user_id = @user_id AND goal_id = @goal_id');
        res.json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.patch('/editGoal/:goal_id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const goal_id = req.params.goal_id;
    const { goal_name, deadline, subgoals } = req.body;
    const updated_at = getCurrentDateTimeUTC7();

    if (!user_id || !goal_id || !goal_name || !deadline || !subgoals) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const transaction = new sql.Transaction(pool);
        await transaction.begin();
        await transaction.request()
            .input('goal_id', sql.Int, goal_id)
            .input('goal_name', sql.NVarChar, goal_name)
            .input('deadline', sql.Date, deadline)
            .input('updated_at', sql.DateTime, updated_at)
            .query('UPDATE Goals SET goal_name = @goal_name, deadline = @deadline, updated_at = @updated_at WHERE goal_id = @goal_id');
        await transaction.request()
            .input('goal_id', sql.Int, goal_id)
            .query('DELETE FROM Subgoals WHERE goal_id = @goal_id');
        for (const subgoal of subgoals) {
            await transaction.request()
                .input('goal_id', sql.Int, goal_id)
                .input('subgoalName', sql.NVarChar, subgoal)
                .input('user_id', sql.Int, user_id)
                .query('INSERT INTO Subgoals (goal_id, subgoalName, user_id) VALUES (@goal_id, @subgoalName, @user_id)');
        }
        await transaction.commit();
        res.status(200).send('Updated');

    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }

});

router.delete('/delete/:goal_id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const goal_id = req.params.goal_id;
    if (!user_id || !goal_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const transaction = new sql.Transaction(pool);
        await transaction.begin();
        await transaction.request()
            .input('goal_id', sql.Int, goal_id)
            .query('DELETE FROM Subgoals WHERE goal_id = @goal_id');
        await transaction.request()
            .input('goal_id', sql.Int, goal_id)
            .query('DELETE FROM Goals WHERE goal_id = @goal_id');
        await transaction.commit();
        res.status(200).send('Deleted');

    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }

});

module.exports = router;