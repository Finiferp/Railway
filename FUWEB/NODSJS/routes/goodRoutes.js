"use strict";

module.exports = function (app) {
  const good = require("../controllers/goodController.js");
  const authenticateToken = require('../middleware/authenticateToken')

  app.route("/good/:id").get(authenticateToken,good.getGoodById);
  app.route("/goods").get(authenticateToken,good.getAllGoods);
};
