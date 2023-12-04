const express = require('express');
const app = express();
const port = 3000;
const bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

/*
const playerRoutes =    require('./routes/playerRoutes');       
const worldRoutes =     require('./routes/worldRoutes');            
const assetRoutes =     require('./routes/assetRoutes');            
const goodRoutes =      require('./routes/goodRoutes');             
const industryRoutes =  require('./routes/industryRoutes');             
const railwayRoutes =   require('./routes/railwayRoutes');              
const stationRoutes =   require('./routes/stationRoutes');              

playerRoutes(app);
worldRoutes(app);
assetRoutes(app);
goodRoutes(app);
industryRoutes(app);
railwayRoutes(app);
stationRoutes(app);
*/

require('./routes/playerRoutes')(app);
require('./routes/worldRoutes')(app);
require('./routes/assetRoutes')(app);
require('./routes/goodRoutes')(app);
require('./routes/industryRoutes')(app);
require('./routes/railwayRoutes')(app);
require('./routes/stationRoutes')(app);
require('./routes/trainRoutes')(app);
app.listen(port);
console.log("Server started");