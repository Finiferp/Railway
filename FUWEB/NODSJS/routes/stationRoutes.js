"use strict";

module.exports = function (app) {
  const station = require("../controllers/stationController.js");
  const authenticateToken = require('../middleware/authenticateToken')

  app.route("/station/create").post(authenticateToken,station.createStation);
  app.route("/station/:id").get(authenticateToken,station.getStationById);
  app.route("/stations").get(authenticateToken,station.getAllStations);
  app.route("/station/name").post(authenticateToken,station.getStationByName);
};
