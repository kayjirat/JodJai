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
    const { title, content, entry_date, mood_rating } = req.body;
    const created_at = getCurrentDateTimeUTC7();
    const updated_at = created_at;
    if (!user_id || !title || !content || !entry_date || !mood_rating) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('title', sql.NVarChar, title)
            .input('content', sql.NText, content)
            .input('entry_date', sql.Date, entry_date)
            .input('mood_rating', sql.Int, mood_rating)
            .input('created_at', sql.DateTime, created_at)
            .input('updated_at', sql.DateTime, updated_at)
            .query('INSERT INTO Journals (user_id, title, content, entry_date, mood_rating, created_at, updated_at) VALUES (@user_id, @title, @content, @entry_date, @mood_rating, @created_at, @updated_at)');

        res.status(201).send('Journal entry created');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/journal/:id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    if (!user_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('journal_id', sql.Int, req.params.id)
            .query('SELECT * FROM Journals WHERE journal_id = @journal_id AND user_id = @user_id');
        if (result.recordset.length === 0) {
            return res.status(404).send('Journal entry not found');
        }
        res.status(200).json(result.recordset[0]);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.patch('/update/:id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const { title, content, entry_date, mood_rating } = req.body;
    const id = req.params.id;
    console.log(entry_date);
    const updated_at = getCurrentDateTimeUTC7();
    if (!user_id || !title || !content || !entry_date || !mood_rating) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('title', sql.NVarChar, title)
            .input('content', sql.NText, content)
            .input('entry_date', sql.Date, entry_date)
            .input('mood_rating', sql.Int, mood_rating)
            .input('updated_at', sql.DateTime, updated_at)
            .input('journal_id', sql.Int, id)
            .query('UPDATE Journals SET title = @title, content = @content, entry_date = @entry_date, mood_rating = @mood_rating, updated_at = @updated_at WHERE journal_id = @journal_id AND user_id = @user_id');
        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Journal entry not found');
        }
        res.status(200).send('Journal entry updated');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.delete('/delete/:id', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    if (!user_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('journal_id', sql.Int, req.params.id)
            .query('DELETE FROM Journals WHERE journal_id = @journal_id AND user_id = @user_id');
        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Journal entry not found');
        }
        res.status(200).send('Journal entry deleted');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/list', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    console.log(user_id);
    if (!user_id) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query('SELECT * FROM Journals WHERE user_id = @user_id');
        res.status(200).json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/ByMonthAndYear/:month/:year', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const month = parseInt(req.params.month);
    const year = parseInt(req.params.year);
    if (!user_id || !month || !year) {
        return res.status(400).send('Bad Request');
    }
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('month', sql.Int, month)
            .input('year', sql.Int, year)
            .query('SELECT * FROM Journals WHERE user_id = @user_id AND MONTH(entry_date) = @month AND YEAR(entry_date) = @year ORDER BY entry_date ASC');
        if (result.recordset.length === 0) {
            return res.status(404).send('Journal entry not found');
        }
        res.status(200).json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

router.get('/weeklysum', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    const startOfWeek = new Date(req.query.startOfWeek);
    if (!user_id || isNaN(startOfWeek)) {
        return res.status(400).send('Bad Request');
    }

    const year = startOfWeek.getFullYear();
    const week = getWeekNumber(startOfWeek);

    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .input('year', sql.Int, year)
            .input('week', sql.Int, week)
            .query(`
                WITH MoodCounts AS (
                    SELECT 
                        DATEPART(YEAR, entry_date) AS year,
                        DATEPART(WEEK, entry_date) AS week,
                        mood_rating,
                        COUNT(*) AS mood_count
                    FROM 
                        Journals
                    WHERE 
                        user_id = @user_id
                        AND DATEPART(YEAR, entry_date) = @year
                        AND DATEPART(WEEK, entry_date) = @week
                    GROUP BY 
                        DATEPART(YEAR, entry_date),
                        DATEPART(WEEK, entry_date),
                        mood_rating
                ),
                MoodTotals AS (
                    SELECT
                        year,
                        week,
                        SUM(mood_count) AS total_count
                    FROM
                        MoodCounts
                    GROUP BY
                        year,
                        week
                )
                SELECT 
                    mc.year,
                    mc.week,
                    mc.mood_rating,
                    mc.mood_count,
                    ROUND((mc.mood_count * 100.0 / mt.total_count), 2) AS mood_percentage
                FROM 
                    MoodCounts mc
                    JOIN MoodTotals mt
                    ON mc.year = mt.year AND mc.week = mt.week
                ORDER BY 
                    mc.year, mc.week, mc.mood_rating
            `);

        res.status(200).json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});
function getWeekNumber(d) {
    d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
    d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
    const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
    const weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
    return weekNo;
}
router.get('/current-weeklysum', verifyJWT, async (req, res) => {
    const user_id = req.user.user_id;
    if (!user_id) {
        return res.status(400).send('Bad Request');
    }

    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query(`
                DECLARE @startOfWeek DATE;
                DECLARE @endOfWeek DATE;

                SET @startOfWeek = DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE));
                SET @endOfWeek = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE));

                WITH MoodCounts AS (
                    SELECT 
                        mood_rating,
                        COUNT(*) AS mood_count
                    FROM 
                        Journals
                    WHERE 
                        user_id = @user_id
                        AND entry_date >= @startOfWeek
                        AND entry_date < @endOfWeek
                    GROUP BY 
                        mood_rating
                ),
                TotalCount AS (
                    SELECT 
                        SUM(mood_count) AS total_count
                    FROM 
                        MoodCounts
                )
                SELECT 
                    mc.mood_rating,
                    mc.mood_count,
                    ROUND((mc.mood_count * 100.0 / tc.total_count), 2) AS mood_percentage
                FROM 
                    MoodCounts mc
                CROSS JOIN 
                    TotalCount tc
                ORDER BY 
                    mc.mood_rating
            `);

        res.status(200).json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});


module.exports = router;