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
        if (!username || !input_password) {
            return res.status(400).json({ error: "invalid input, object invalid" });
        }
        let salt = crypto.randomBytes(32).toString("hex");
        console.log(salt);
        let password = crypto.pbkdf2Sync(input_password, salt, 10000, 512, "sha512").toString("hex");
        const inputData = { username, password, salt };
        const dbOutput = await db.spRegister(inputData);
        const { status_code, message, user, new_world_created } = dbOutput[0][0].result;
        if(new_world_created===1){
            generateNewWorld();
        }
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
        if (!username || !input_password || salt[0][0].salt===null) {
            return res.status(400).json({ error: "invalid input, object invalid" });
        }
       
        const password = validatePassword(input_password, salt[0][0].salt);
        const token = generateAuthToken(username);
        const inputData = { username, password, token };
        const dbOutput = await db.spLogin(inputData);
        const { status_code, message, user } = dbOutput[0][0].result;

        res.status(status_code).json({
            message,
            user: user,
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
    const token = jwt.sign(username, process.env.JWT_KEY || 'RailwayImperiumSecret');
    return token;
};


function generateNewWorld(){

}

module.exports = {
    getPlayerById,
    getAllPlayers,
    register,
    login
};