"use strict";

const db = require("../DB");

const getAllIndustries = async (req, res) => {
    try {
        const dbOutput = await db.spGetIndustries();
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

const getIndustryById = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    try {
        const dbOutput = await db.spGetIndustry(JSON.stringify(inputData));
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

const createIndustry = async (req, res) => {
    try {
        const {name, idAsset, type} = req.body;
        const inputData = { name, idAsset, type};
        const dbOutput = await db.spCreateIndustry(inputData);
        const {status_code, message, Industry} = dbOutput[0][0].result;
      
        res.status(status_code).json({
            message,
            Industry: Industry
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

module.exports = {
    getAllIndustries,
    getIndustryById,
    createIndustry
};