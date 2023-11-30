"use strict";

const db = require("../DB");

const getAllTrains = async (req, res) => {
    try {
        const dbOutput = await db.spGetTrains();
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

const getTrainById = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    try {
        const dbOutput = await db.spGetTrain(JSON.stringify(inputData));
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

// no implemented yet
const createTrain = async (req, res) => {
    /*try {
        const {railway, assetId} = req.body;
        const inputData = { railway, assetId};
        const dbOutput = await db.spCreateTrain(inputData);
        const {status_code, message, train} = dbOutput[0][0].result;
      
        res.status(status_code).json({
            message,
            train: train
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }*/
};

module.exports = {
    getAllTrains,
    getTrainById,
    createTrain
};