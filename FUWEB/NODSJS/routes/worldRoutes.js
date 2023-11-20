"use strict";

module.exports = function (app) {
  const world = require("../controllers/worldController.js");
  
  app.route("/world/:id").get(world.getWorldById);
  app.route("/worlds").get(world.getAllWorlds);
};
