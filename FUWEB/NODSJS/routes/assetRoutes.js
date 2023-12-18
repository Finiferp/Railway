"use strict";

module.exports = function (app) {
  const authenticateToken = require('../middleware/authenticateToken')
  const asset = require("../controllers/assetController.js");

  //app.route("/asset/create").post(authenticateToken,asset.createAsset);
  app.route("/asset/:id").get(authenticateToken,asset.getAssetById);
  app.route("/assets").get(authenticateToken,asset.getAllAssets);
  app.route("/asset/player/:id").get(authenticateToken,asset.getPlayerAssets);
  app.route("/asset/buy").post(authenticateToken,asset.buyAsset);
  app.route("/asset/station").post(authenticateToken,asset.getAssetsStation);
  app.route("/asset/world/:id").get(authenticateToken,asset.getWorldAssets);
};
