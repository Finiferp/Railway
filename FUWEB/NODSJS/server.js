const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const port = 3000;
const bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

/*
// take care of "*.js"
const routesPath = path.join(__dirname, "routes");
const routeFiles = fs.readdirSync(routesPath);

routeFiles.forEach((file) => {
    const routeFilePath = path.join(routesPath, file);
    require(routeFilePath)(app);
});*/

let playerRoutes = require('./routes/playerRoutes');

playerRoutes(app);
app.listen(port);
console.log("Server started");