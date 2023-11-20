"use strict";

module.exports = function (app) {
  const asset = require("../controllers/assetController.js");

  app.route("/asset/create").post(asset.createAsset);
  app.route("/asset/:id").get(asset.getAssetById);
  app.route("/assets").get(asset.getAllAssets);
};
