const jwt = require('jsonwebtoken');
const jwtSecret = process.env.SECRET_KEY;
require('dotenv').config();

const verifyJWT = (req, res, next) => {
    const token = req.cookies.token;
    if (!token) {
        return res.status(401).send('Unauthorized: No token provided');
    }

    jwt.verify(token, jwtSecret, (err, decoded) => {
        if (err) {
            return res.status(401).send('Unauthorized: Invalid token');
        }
        req.user = decoded;
        next();
    });
};

module.exports = verifyJWT;