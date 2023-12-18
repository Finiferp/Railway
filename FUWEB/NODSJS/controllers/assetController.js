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
const getPlayerAssets = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
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