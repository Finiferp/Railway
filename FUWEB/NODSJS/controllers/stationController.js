"use strict";

const db = require("../DB");

const getAllStations = async (req, res) => {
    try {
        const dbOutput = await db.spGetStations();
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

const getStationById = async (req, res) => {
    const id = parseInt(req.params.id);
    const inputData = { id };
    try {
        const dbOutput = await db.spGetStation(JSON.stringify(inputData));
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

const createStation = async (req, res) => {
    try {
        const {name, assetId} = req.body;
        const inputData = { name, assetId};
        const dbOutput = await db.spCreateStation(inputData);
        const {status_code, message, station} = dbOutput[0][0].result;
      
        res.status(status_code).json({
            message,
            station: station
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal Server Error');
    }
};

module.exports = {
    getAllStations,
    getStationById,
    createStation
};