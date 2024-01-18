const jwt = require('jsonwebtoken');
const db = require("../DB");

/**
 * Middleware function to authenticate and verify JWT token in the Authorization header.
 *
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} res - Express response object.
 * @param {Function} next - Express next middleware function.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
async function authenticateToken(req, res, next) {
    const token = req.header('Authorization');

    if (!token) {
        return res.status(401).json({ error: 'No authorization provided. Expecting token!' });
    }
    try {
        // Check if the token exists in the database
        const tokenExistsResult = await db.spCheckTokenExists(token);
        const tokenExists = tokenExistsResult[0][0].result;
        if (!tokenExists) {
            return res.status(401).json({ error: 'Unauthorized: Invalid token' });
        }
        // Verify the JWT token
        jwt.verify(token,'RailwayImperiumSecret', (err, decoded) => {
            if (err) {
                if (err.name === 'TokenExpiredError') {
                    db.spDeleteToken(token);
                    return res.status(401).json({ error: 'Unauthorized: Token expired' });
                } else {
                    return res.status(403).json({ error: 'Forbidden: Invalid token' });
                }
            }
            // Attach decoded information to the request object
            req.decoded = decoded;
            next();
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
}

module.exports = authenticateToken;