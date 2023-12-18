"use strict";

module.exports = function (app) {
  const train = require("../controllers/trainController.js");
  const authenticateToken = require('../middleware/authenticateToken')

  app.route("/train/create").post(authenticateToken,train.createTrain);
  app.route("/train/:id").get(authenticateToken,train.getTrainById);
  app.route("/trains").get(authenticateToken,train.getAllTrains);
  app.route("/train/create").post(authenticateToken,train.createTrain);
  app.route("/train/delete").delete(authenticateToken,train.deleteTrain);
  app.route("/train/demand").post(authenticateToken,train.demandTrain);
  
};
