"use strict";

const db = require("../DB");

/**
 * Get information for all trains.
 *
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
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

/**
 * Get information for a specific train by ID.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with parameters.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
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

/**
 * Create a new train.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing name, idRailway, idAsset_Starts, and idAsset_Destines.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
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

/**
 * Delete a train.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing trainId and userId.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
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

/**
 * Demand a train for transporting goods.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing assetFromId, assetToId, railwayId, goodId, and amount.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
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