require('dotenv').config();
const jwt = require('jsonwebtoken');
const jwtSecret = process.env.SECRET_KEY;

const verifyJWT = (req, res, next) => {
    const token = req.cookies.token || req.headers.authorization?.split(' ')[1];
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
