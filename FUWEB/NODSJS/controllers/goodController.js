"use strict";

const db = require("../DB");

const getAllGoods = async (req, res) => {
    try {
        const dbOutput = await db.spGetGoods();
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



const getGoodById = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    try {
        const dbOutput = await db.spGetGood(JSON.stringify(inputData));
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
    getAllGoods,
    getGoodById
};