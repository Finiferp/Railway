"use strict"

module.exports = function (app) {
    const player = require("../controllers/playerController.js")
    const authenticateToken = require('../middleware/authenticateToken')

    app.route("/register").post(player.register);
    app.route("/login").post(player.login);
    app.route("/player/:id").get(authenticateToken,player.getPlayerById);
    app.route("/players").get(authenticateToken,player.getAllPlayers);
}