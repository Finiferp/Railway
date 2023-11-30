"use strict";

module.exports = function (app) {
  const railway = require("../controllers/railwayController.js");
  const authenticateToken = require('../middleware/authenticateToken')

  app.route("/railway/create").post(authenticateToken,railway.createRailway);
  app.route("/railway/:id").get(authenticateToken,railway.getRailwayById);
  app.route("/railways").get(authenticateToken,railway.getAllRailways);
};
