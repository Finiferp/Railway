"use strict";

const db = require("../DB");

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

const createAsset = async (req, res) => {
    try {
        const { type, name, position , worldId} = req.body;
        const inputData = { type, name, position, worldId};
        const dbOutput = await db.spCreateAsset(inputData);
        const {status_code, message, asset} = dbOutput[0][0].result;
      
        res.status(status_code).json({
            message,
            asset: asset
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

module.exports = {
    getAllAssets,
    getAssetById,
    createAsset
};