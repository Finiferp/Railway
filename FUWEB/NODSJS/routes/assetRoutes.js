"use strict";

module.exports = function (app) {
  const authenticateToken = require('../middleware/authenticateToken')
  const asset = require("../controllers/assetController.js");

  app.route("/asset/create").post(authenticateToken,asset.createAsset);
  app.route("/asset/:id").get(authenticateToken,asset.getAssetById);
  app.route("/assets").get(authenticateToken,asset.getAllAssets);
};
