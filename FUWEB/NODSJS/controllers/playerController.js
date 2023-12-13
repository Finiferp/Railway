"use strict";

const db = require("../DB");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");

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

const register = async (req, res) => {
    try {
        const { username, input_password } = req.body;
        console.log(req.body);
        if (!username || !input_password) {
            return res.status(400).json({ error: "invalid input, object invalid" });
        }
        let salt = crypto.randomBytes(32).toString("hex");
        let password = crypto.pbkdf2Sync(input_password, salt, 10000, 512, "sha512").toString("hex");
        const inputData = { username, password, salt };
        const dbOutput = await db.spRegister(inputData);
        const { status_code, message, user, new_world_created, new_world_id } = dbOutput[0][0].result;
        if (new_world_created === 1) {
            generateWorld(new_world_id);
        }
        console.log(message);
        res.status(status_code).json({
            message,
            user: user,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

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
            token: token
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

function validatePassword(password, salt) {
    let hashedPassword = crypto.pbkdf2Sync(password, salt, 10000, 512, "sha512").toString("hex");
    return hashedPassword;
}


function generateAuthToken(username) {
    const payload = {
        username: username,
        exp: Math.floor(Date.now() / 1000) + 12 * 3600,
    };
    const token = jwt.sign(payload, 'RailwayImperiumSecret');
    console.log(jwt.verify(token, 'RailwayImperiumSecret'));
    return token;
};

// Function to generate random positions with a minimum distance
function generateRandomPosition(existingPositions, gridSize, minDistance) {
    let x, y;
    do {
        x = Math.floor(Math.random() * gridSize);
        y = Math.floor(Math.random() * gridSize);
    } while (hasMinDistance(existingPositions, x, y, minDistance));

    return { x, y };
}

// Function to check if a position has a minimum distance from existing positions
function hasMinDistance(existingPositions, newX, newY, minDistance) {
    for (const { x, y } of existingPositions) {
        const distance = Math.hypot(newX - x, newY - y);
        if (distance < minDistance) {
            return true; // Too close, try again
        }
    }
    return false; // Minimum distance satisfied
}

// Function to generate a world with towns and rural businesses
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

        for (let i = 0; i < ruralBusinesses.length; i++) {
            const ruralBusiness = ruralBusinesses[i];
            const JSONR = JSON.stringify({
                'type': 'RURALBUSINESS',
                'name': 'Rural Business' + i,
                'position': ruralBusiness,
                'worldId': worldId
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
    login
};