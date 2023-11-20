"use strict";

module.exports = function (app) {
  const industry = require("../controllers/industryController.js");

  app.route("/industry/create").post(industry.createIndustry);
  app.route("/industry/:id").get(industry.getIndustryById);
  app.route("/industries").get(industry.getAllIndustries);
};
