"use strict";

module.exports = function (app) {
  const good = require("../controllers/goodController.js");

  app.route("/good/:id").get(good.getGoodById);
  app.route("/goods").get(good.getAllGoods);
};
