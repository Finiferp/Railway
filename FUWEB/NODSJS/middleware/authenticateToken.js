const jwt = require('jsonwebtoken');
const db = require("../DB");


async function authenticateToken(req, res, next) {
    const token = req.header('Authorization');

    if (!token) {
        return res.status(401).json({ error: 'No authorization provided. Expecting token!' });
    }
    try {
        const tokenExistsResult = await db.spCheckTokenExists(token);
        const tokenExists = tokenExistsResult[0][0].result;
        if (!tokenExists) {
            return res.status(401).json({ error: 'Unauthorized: Invalid token' });
        }

        jwt.verify(token, process.env.JWT_KEY || 'RailwayImperiumSecret', (err, decoded) => {
            if (err) {
                if (err.name === 'TokenExpiredError') {
                    db.spDeleteToken(token);
                    return res.status(401).json({ error: 'Unauthorized: Token expired' });
                } else {
                    return res.status(403).json({ error: 'Forbidden: Invalid token' });
                }
            }
            req.decoded = decoded;
            next();
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
}

module.exports = authenticateToken;