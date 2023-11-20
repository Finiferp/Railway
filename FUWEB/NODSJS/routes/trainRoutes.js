"use strict";

module.exports = function (app) {
  const train = require("../controllers/trainController.js");

  app.route("/train/create").post(train.createTrain);
  app.route("/train/:id").get(train.getTrainById);
  app.route("/trains").get(train.getAllTrains);
};
