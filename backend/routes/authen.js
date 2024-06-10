const route = require('express').Router();
const sql = require('mssql');
const bcrypt = require('bcrypt');
const cookieParser = require('cookie-parser');
const jwt = require('jsonwebtoken');
const jwtSecret = process.env.SECRET_KEY;
const moment = require('moment-timezone');
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

route.post('/login', async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('username', sql.NVarChar, username)
            .query('SELECT * FROM users WHERE username = @username');

        if (result.recordset.length === 0) {
            return res.status(401).send('Unauthorized!');
        }

        const user = result.recordset[0];
        const passwordMatch = bcrypt.compareSync(password, user.hashed_password);

        if (!passwordMatch) {
            return res.status(401).send('Unauthorized! Wrong password!');
        }

        const token = jwt.sign({ user_id: user.user_id, username: user.username }, jwtSecret, { expiresIn: '180d' });

        res.cookie('token', token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production'
        });

        res.json({ token, user });
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

route.post('/register', async (req, res) => {
    const { username, password, email } = req.body;
    if (!username || !password || !email) {
        return res.status(400).send('Bad Request');
    }

    const hashedPassword = bcrypt.hashSync(password, 10);
    const member_status = 0;
    const created_at = getCurrentDateTimeUTC7();
    try {
        const pool = await sql.connect(dbConfig);
        const userCheckResult = await pool.request()
            .input('username', sql.NVarChar, username)
            .input('email', sql.NVarChar, email)
            .query('SELECT * FROM users WHERE username = @username OR email = @email');

        if (userCheckResult.recordset.length > 0) {
            return res.status(409).send('User already exists');
        }
        await pool.request()
            .input('username', sql.NVarChar, username)
            .input('hashed_password', sql.NVarChar, hashedPassword)
            .input('email', sql.NVarChar, email)
            .input('member_status', sql.Bit, member_status)
            .input('created_at', sql.DateTime, created_at)
            .query('INSERT INTO users (username, hashed_password, email, member_status, created_at) VALUES (@username, @hashed_password, @email, @member_status, @created_at)');
        
        const token = jwt.sign({ user_id: user.user_id, username: user.username }, jwtSecret, { expiresIn: '180d' });
        res.cookie('token', token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production'
        });
        res.status(201).send('Created');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

module.exports = route;
