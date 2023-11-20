"use strict";

module.exports = function (app) {
  const station = require("../controllers/stationController.js");

  app.route("/station/create").post(station.createStation);
  app.route("/station/:id").get(station.getStationById);
  app.route("/stations").get(station.getAllStations);
};
