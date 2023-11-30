"use strict";

module.exports = function (app) {
  const industry = require("../controllers/industryController.js");
  const authenticateToken = require('../middleware/authenticateToken')

  app.route("/industry/create").post(authenticateToken,industry.createIndustry);
  app.route("/industry/:id").get(authenticateToken,industry.getIndustryById);
  app.route("/industries").get(authenticateToken,industry.getAllIndustries);
};
