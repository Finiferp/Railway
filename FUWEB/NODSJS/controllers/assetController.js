"use strict";

const db = require("../DB");

/**
 * Get all assets from the database.
 *
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getAllAssets = async (req, res) => {
    try {
        const dbOutput = await db.spGetAssets();
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
 * Get a specific asset by its ID.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with parameters.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getAssetById = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    try {
        const dbOutput = await db.spGetAsset(JSON.stringify(inputData));
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
 * Get assets owned by a specific player.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with parameters.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getPlayerAssets = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    console.log(inputData);
    try {
        const dbOutput = await db.spGetUserAssets(JSON.stringify(inputData));
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
 * Purchase an asset for a specific user.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing userId and assetId.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const buyAsset = async (req, res) => {
    const { userId, assetId } = req.body;
    const inputData = { userId, assetId };
   
    try {
        const dbOutput = await db.spBuyAssets(JSON.stringify(inputData));
   
        const { status_code, message, asset } = dbOutput[0][0].result;

        res.status(status_code).json({
            message,
            data: asset,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

/**
 * Gets an assets stations.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with body containing assetId.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getAssetsStation = async (req, res) => {
    const { assetId } = req.body;
    const inputData = { assetId };

    try {
        const dbOutput = await db.spGetAssetsStation(JSON.stringify(inputData));
       
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
 * Get assets in a specific world.
 *
 * @async
 * @function
 * @param {Object} req - Express request object with parameters.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A Promise that resolves when the operation is complete.
 */
const getWorldAssets = async (req, res) => {
    const worldId = parseInt(req.params.id);
    const inputData = { worldId };
    try {
        const dbOutput = await db.spWorldsAssets(JSON.stringify(inputData));
      
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
    getAllAssets,
    getAssetById,
    getPlayerAssets,
    buyAsset,
    getAssetsStation,
    getWorldAssets
};