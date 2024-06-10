const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');
require('dotenv').config();

const Routes = require('./routes/allroutes');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());


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


sql.connect(dbConfig).catch(err => {
    console.error('Database connection failed', err);
});


app.get('/api/test', async (req, res) => {
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request().query('SELECT text FROM test');
        res.json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

app.post('/api/test', async (req, res) => {
    const { text } = req.body;
    if (!text) {
        return res.status(400).send('Bad Request');
    }

    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('text', sql.NVarChar, text)
            .query('INSERT INTO test (text) VALUES (@text)');
        res.status(201).send('Created');
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Internal Server Error');
    }
});

new Routes(app).getRoutes();
// Start the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
