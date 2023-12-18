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


const createTrain = async (req, res) => {
    try {
        const { name, idRailway, idAsset_Starts, idAsset_Destines } = req.body;
        const inputData = { name, idRailway, idAsset_Starts, idAsset_Destines };
        const dbOutput = await db.spCreateTrain(inputData);
        const { status_code, message, train } = dbOutput[0][0].result;

        res.status(status_code).json({
            message: message,
            train: train
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

const deleteTrain = async (req, res) => {
    try {
        const { trainId, userId } = req.body;
        const inputData = { trainId, userId };
        const dbOutput = await db.spDeleteTrain(inputData);
        const { status_code, message } = dbOutput[0][0].result;

        res.status(status_code).json({
            message: message
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};
const demandTrain = async (req, res) => {
    try {
        const { assetFromId, assetToId, railwayId, goodId, amount } = req.body;
        const inputData = { assetFromId, assetToId, railwayId, goodId, amount };
        const dbOutput = await db.spDemandTrain(inputData);
        const { status_code, message } = dbOutput[0][0].result;

        res.status(status_code).json({
            message: message
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

module.exports = {
    getAllTrains,
    getTrainById,
    createTrain,
    deleteTrain,
    demandTrain
};