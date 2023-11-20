"use strict";

module.exports = function (app) {
  const railway = require("../controllers/railwayController.js");

  app.route("/railway/create").post(railway.createRailway);
  app.route("/railway/:id").get(railway.getRailwayById);
  app.route("/railways").get(railway.getAllRailways);
};
