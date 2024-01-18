"use strict";

const db = require("../DB");

/**
 * Get all industries from the database.
 *
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
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

/**
 * Get a specific industry by its ID.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with parameters.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getIndustryById = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    try {
        const dbOutput = await db.spGetIndustry(JSON.stringify(inputData));
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
 * Create a new industry.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing name, idAsset, and type.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const createIndustry = async (req, res) => {
    try {
        const {name, idAsset, type} = req.body;
        const inputData = { name, idAsset, type};
        const dbOutput = await db.spCreateIndustry(inputData);
        const {status_code, message, industry} = dbOutput[0][0].result;
        res.status(status_code).json({
            message: message,
            industry: industry
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