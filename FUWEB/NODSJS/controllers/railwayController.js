"use strict";

const db = require("../DB");

/**
 * Get information for all railways.
 *
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getAllRailways = async (req, res) => {
    try {
        const dbOutput = await db.spGetRailways();
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
 * Get information for a specific railway by ID.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with parameters.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getRailwayById = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    try {
        const dbOutput = await db.spGetRailway(JSON.stringify(inputData));
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
 * Create a new railway.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing station1Id and station2Id.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const createRailway = async (req, res) => {
    try {
        const {station1Id, station2Id} = req.body;
        const inputData = { station1Id, station2Id};
        const dbOutput = await db.spCreateRailway(inputData);
        const {status_code, message, railway} = dbOutput[0][0].result;
      
        res.status(status_code).json({
            message,
            railway: railway
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

module.exports = {
    getAllRailways,
    getRailwayById,
    createRailway
};