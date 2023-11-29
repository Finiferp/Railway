const express = require('express');
const app = express();
const port = 3000;
const bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


const playerRoutes = require('./routes/playerRoutes');
const worldRoutes = require ('./routes/worldRoutes');
const assetRoutes = require ('./routes/assetRoutes');
const goodRoutes = require ('./routes/goodRoutes');
const industryRoutes = require ('./routes/industryRoutes')

playerRoutes(app);
worldRoutes(app);
assetRoutes(app);
goodRoutes(app);
industryRoutes(app);

app.listen(port);
console.log("Server started");