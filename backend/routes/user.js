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

router.get('/profile', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    if (!user_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query('SELECT * FROM Users WHERE user_id = @user_id');
        res.status(200).json(result.recordset[0]);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/check', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    if (!user_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query('SELECT member_status, DATEDIFF(day, created_at, GETDATE()) as account_age FROM Users WHERE user_id = @user_id');
        
        if (result.recordset.length === 0) {
            return res.status(404).send('Membership information not found');
        }
        
        const membershipStatus = result.recordset[0].member_status;
        const accountAgeDays = result.recordset[0].account_age;
        console.log(membershipStatus)
        console.log(accountAgeDays)
        if ((membershipStatus === true && accountAgeDays <= 3) || (membershipStatus === false && accountAgeDays <= 3) || (membershipStatus === true && accountAgeDays >= 3)) {
            return res.status(200).json(true); 
        }
        res.status(200).json(false);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/membership', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    if (!user_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query('SELECT member_status FROM Memberships WHERE user_id = @user_id');
        res.status(200).json(result.recordset[0]);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.post('/membership', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const {stripe_payment_id} = req.body;
    const created_at = getCurrentDateTimeUTC7();
    const payment_status = 1;
    if (!user_id || !stripe_payment_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('stripe_payment_id', sql.NVarChar, stripe_payment_id)
            .input('created_at', sql.DateTime, created_at)
            .input('payment_status', sql.Bit, payment_status)
            .query('INSERT INTO Memberships (user_id, stripe_payment_id, created_at, payment_status) VALUES (@user_id, @stripe_payment_id, @created_at, @payment_status)');
        const user = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query('UPDATE Users SET member_status = 1 WHERE user_id = @user_id');
        res.status(201).send('Membership created');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.patch('/edit', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const { username } = req.body;
    if (!user_id || !username) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('username', sql.NVarChar, username)
            .query('UPDATE Users SET username = @username WHERE user_id = @user_id');
        res.status(200).send('User updated');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.post('/feedback', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const { feedback } = req.body;
    const created_at = getCurrentDateTimeUTC7();
    if (!user_id || !feedback) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('feedback', sql.NVarChar, feedback)
            .input('created_at', sql.DateTime, created_at)
            .query('INSERT INTO Feedbacks (user_id, feedback, created_at) VALUES (@user_id, @feedback, @created_at)');
        res.status(201).send('Feedback submitted');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

module.exports = router;