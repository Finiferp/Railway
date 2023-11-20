"use strict"

module.exports = function (app) {
    const player = require("../controllers/playerController.js")

    app.route("/register").post(player.register);
    app.route("/login").post(player.login);
    app.route("/player/:id").get(player.getPlayerById);
    app.route("/players").get(player.getAllPlayers);
}