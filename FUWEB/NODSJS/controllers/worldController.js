"use strict";

const db = require("../DB");

const getAllWorlds = async (req, res) => {
    try {
        const dbOutput = await db.spGetWorlds();
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



const getWorldById = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    try {
        const dbOutput = await db.spGetWorld(JSON.stringify(inputData));
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


module.exports = {
    getAllWorlds,
    getWorldById
};