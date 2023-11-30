"use strict";

module.exports = function (app) {
  const world = require("../controllers/worldController.js");
  const authenticateToken = require('../middleware/authenticateToken')

  app.route("/world/:id").get(authenticateToken,world.getWorldById);
  app.route("/worlds").get(authenticateToken,world.getAllWorlds);
};
