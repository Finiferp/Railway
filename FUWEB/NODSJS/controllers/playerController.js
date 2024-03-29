"use strict";

const db = require("../DB");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");

/**
 * Get player information by ID.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with parameters.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getPlayerById = async (req, res) => {
    const userId = parseInt(req.params.id);
    const inputData = { userId };
    try {
        const dbOutput = await db.spGetPlayer(JSON.stringify(inputData));
        const { status_code, message, data } = dbOutput[0][0].result;
        res.status(status_code).json({
            message,
            data: data,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * Get information for all players.
 *
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getAllPlayers = async (req, res) => {
    try {
        const dbOutput = await db.spGetPlayers();
        const { status_code, message, data } = dbOutput[0][0].result;

        res.status(status_code).json({
            message,
            data: data,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * Register a new player.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing username and input_password.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const register = async (req, res) => {
    try {
        const { username, input_password } = req.body;
        if (!username || !input_password) {
            return res.status(400).json({ error: "invalid input, object invalid" });
        }
        let salt = crypto.randomBytes(32).toString("hex");
        let password = crypto.pbkdf2Sync(input_password, salt, 10000, 128, "sha512").toString("hex");
        const inputData = { username, password, salt };
        const dbOutput = await db.spRegister(inputData);
        const { status_code, message, user, new_world_created, new_world_id } = dbOutput[0][0].result;
        if (new_world_created === 1) {
            generateWorld(new_world_id);
        }
        console.log(message);
        res.status(status_code).json({
            message: message,
            user: user,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * Log in a player.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing username and input_password.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const login = async (req, res) => {
    try {
        const { username, input_password } = req.body;
        const salt = await db.spGetSalt(username);
        if (!username || !input_password || salt[0][0].salt === null) {
            return res.status(400).json({ message: "invalid input, object invalid" });
        }

        const password = validatePassword(input_password, salt[0][0].salt);
        const token = generateAuthToken(username);
        const inputData = { username, password, token };
        const dbOutput = await db.spLogin(inputData);
        const { status_code, message, user } = dbOutput[0][0].result;

        res.status(status_code).json({
            message,
            user: user,
            token: token,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * Get stockpiled goods per asset of a player.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing userId.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getPlayerStockpiles = async (req, res) => {
    try {
       
        const { userId } = req.body;
        const inputData = { userId };
       
        const dbOutput = await db.spGetPlayerStockpiles(inputData);
        const { status_code, message, data } = dbOutput[0][0].result;
      
        res.status(status_code).json({
            message,
            data: data,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * Get needs per asset of a player.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing userId.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getPlayerNeeds = async (req, res) => {
    try {
       
        const { userId } = req.body;
        const inputData = { userId };
      
        const dbOutput = await db.spGetPlayerNeeds(inputData);
        const { status_code, message, data } = dbOutput[0][0].result;
       
        res.status(status_code).json({
            message: message,
            data: data,
        });

    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * Get railways of a player.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing userId.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getPlayerRailways = async (req, res) => {
    try {
       
        const { userId } = req.body;
        const inputData = { userId };
       
        const dbOutput = await db.spPlayerRailways(inputData);
        const { status_code, message, data } = dbOutput[0][0].result;
       
        res.status(status_code).json({
            message,
            data: data,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * Get trains of a player.
 * @async
 * @function
 * @param {Object} req - Express request object with body containing userId.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getPlayersTrains = async (req, res) => {
    try {
       
        const { userId } = req.body;
        const inputData = { userId };
       
        const dbOutput = await db.spGetPlayersTrains(inputData);
        const { status_code, message, data } = dbOutput[0][0].result;
        
        res.status(status_code).json({
            message,
            data: data,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};


/**
 * 
 * Get industries of a player.
 * @async
 * @function
 * @param {Object} req - Express request object with body containing userId.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getPlayerIndustries = async (req, res) => {
    try {
       
        const { userId } = req.body;
        const inputData = { userId };
       
        const dbOutput = await db.spGetPlayerIndustries(inputData);
        const { status_code, message, data } = dbOutput[0][0].result;
        
        res.status(status_code).json({
            message,
            data: data,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * 
 * Validate a password using the provided salt.
 * @function
 * @param {string} password - The password to be validated.
 * @param {string} salt - The salt used for password hashing.
 * @returns {string} - The hashed password.
 */
function validatePassword(password, salt) {
    let hashedPassword = crypto.pbkdf2Sync(password, salt, 10000, 512, "sha512").toString("hex");
    return hashedPassword;
}

/**
 * 
 * Generate an authentication token for a user.
 * @function
 * @param {string} username - The username for which the token is generated.
 * @returns {string} - The generated authentication token.
 */
function generateAuthToken(username) {
    const payload = {
        username: username,
        exp: Math.floor(Date.now() / 1000) + 12 * 3600,
    };
    const token = jwt.sign(payload, 'RailwayImperiumSecret');
 
    return token;
};

/**
 * 
 * Generate a random position for assets on the world map, ensuring minimum distance from existing positions.
 * @function
 * @param {Array} existingPositions - Array of existing positions to check for minimum distance.
 * @param {number} gridSize - The size of the world map grid.
 * @param {number} minDistance - The minimum distance required between positions.
 * @returns {Object} - The generated random position.
 */
function generateRandomPosition(existingPositions, gridSize, minDistance) {
    let x, y;
    do {
        x = Math.floor(Math.random() * gridSize);
        y = Math.floor(Math.random() * gridSize);
    } while (hasMinDistance(existingPositions, x, y, minDistance));

    return { x, y };
}

/**
 * 
 * Check if a new position has a minimum distance from existing positions.
 * @function
 * @param {Array} existingPositions - Array of existing positions to check against.
 * @param {number} newX - The x-coordinate of the new position.
 * @param {number} newY - The y-coordinate of the new position.
 * @param {number} minDistance - The minimum distance required between positions.
 * @returns {boolean} - True if the minimum distance is satisfied, false otherwise.
 */
function hasMinDistance(existingPositions, newX, newY, minDistance) {
    for (const { x, y } of existingPositions) {
        const distance = Math.hypot(newX - x, newY - y);
        if (distance < minDistance) {
            return true; // Too close, try again
        }
    }
    return false; // Minimum distance satisfied
}

/**
 * Generate a world with towns and rural businesses.
 * @async
 * @function
 * @param {number} worldId - The ID of the world to be generated.
 * @returns {Promise<void>} - A Promise that resolves when the world generation is complete.
 */
async function generateWorld(worldId) {
    const gridSize = 1000;
    const minDistance = 50;
    const numTowns = 15;
    const numRuralBusinesses = 30;

    const towns = [];
    const ruralBusinesses = [];

    // Generate towns
    for (let i = 0; i < numTowns; i++) {
        const position = generateRandomPosition([...towns, ...ruralBusinesses], gridSize, minDistance);
        towns.push(position);
    }

    // Generate rural businesses
    for (let i = 0; i < numRuralBusinesses; i++) {
        const position = generateRandomPosition([...towns, ...ruralBusinesses], gridSize, minDistance);
        ruralBusinesses.push(position);
    }

    try {
        for (let i = 0; i < towns.length; i++) {
            const town = towns[i];
            const JSONR = JSON.stringify({
                'type': 'TOWN',
                'name': 'Town ' + i,
                'position': town,
                'worldId': worldId
            });
            const res = await db.spCreateAsset(JSONR);

        }

        for (let i = 1; i < ruralBusinesses.length+1; i++) {
            const ruralBusiness = ruralBusinesses[i];
            let business;
            if (i < 5) {
                business = 'RANCH';
            } else if (i < 10) {
                business = 'FIELD';
            } else if (i < 15) {
                business = 'FARM';
            } else if (i < 20) {
                business = 'LUMBERYARD';
            } else if (i < 25) {
                business = 'PLANTATION';
            } else {
                business = 'MINE';
            }
            const JSONR = JSON.stringify({
                'type': 'RURALBUSINESS',
                'name': 'Rural Business' + i,
                'position': ruralBusiness,
                'worldId': worldId,
                'business': business
            });
            const res = await db.spCreateAsset(JSONR);

        }
    } catch (error) {
        console.error(error);
    }

}

module.exports = {
    getPlayerById,
    getAllPlayers,
    register,
    login,
    getPlayerStockpiles,
    getPlayerNeeds,
    getPlayerRailways,
    getPlayersTrains,
    getPlayerIndustries
};