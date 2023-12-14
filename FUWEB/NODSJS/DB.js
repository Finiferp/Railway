const mysql = require('mysql2/promise');
const DBConnectOpts = {
    host: '192.168.131.123',
    port: 3306,
    charset: 'utf8mb4',
    user: 'daniel',
    password: 'q1w2e3r4t5!',
    database: 'RailwayProject',
};
const pool = mysql.createPool(DBConnectOpts);

const executeQuery = async (sql, values) => {
    const connection = await pool.getConnection();
    try {
        const [results] = await connection.execute(sql, values);
        return results;
    } finally {
        connection.release();
    }
};

const spLogin = async (JSON) => {
    const sql = 'CALL sp_Login(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spRegister = async (JSON) => {
    const sql = 'CALL sp_Register(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetPlayer = async (JSON) => {
    const sql = 'CALL sp_getPlayer(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetPlayers = async () => {
    const sql = 'CALL sp_getPlayers()';
    return await executeQuery(sql);
};

const spGetSalt = async (username) => {
    const sql = 'CALL sp_getSalt(?)';
    const values = [username];
    return await executeQuery(sql, values);
};

const spGetWorld = async (JSON) => {
    const sql = 'CALL sp_getWorld(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetWorlds = async () => {
    const sql = 'CALL sp_getWorlds()';
    return await executeQuery(sql);
};


const spCreateAsset = async (JSON) => {
    const sql = 'CALL sp_createAsset(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetAssets = async () => {
    const sql = 'CALL sp_getAssets()';
    return await executeQuery(sql);
};

const spGetAsset = async (JSON) => {
    const sql = 'CALL sp_getAsset(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetGood = async (JSON) => {
    const sql = 'CALL sp_getGood(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetGoods = async () => {
    const sql = 'CALL sp_getGoods()';
    return await executeQuery(sql);
};

const spGetIndustry = async (JSON) => {
    const sql = 'CALL sp_getIndustry(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetIndustries = async () => {
    const sql = 'CALL sp_getIndustries()';
    return await executeQuery(sql);
};

const spCreateIndustry = async (JSON) => {
    const sql = 'CALL sp_createIndustry(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetRailways = async () => {
    const sql = 'CALL sp_getRailways()';
    return await executeQuery(sql);
}

const spGetRailway = async (JSON) => {
    const sql = 'CALL sp_getRailway(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spCreateRailway = async (JSON) => {
    const sql = 'CALL sp_createRailway(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetStations = async () => {
    const sql = 'CALL sp_getStations()';
    return await executeQuery(sql);
}

const spGetStation = async (JSON) => {
    const sql = 'CALL sp_getStation(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spCreateStation = async (JSON) => {
    const sql = 'CALL sp_createStation(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spGetTrains = async () => {
    const sql = 'CALL sp_getTrains()';
    return await executeQuery(sql);
}

const spGetTrain = async (JSON) => {
    const sql = 'CALL sp_getTrain(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spCreateTrain = async (JSON) => {
    const sql = 'CALL sp_createTrain(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

const spCheckTokenExists = async (token) =>{
    const sql = 'CALL sp_checkTokenExists(?)';
    const values = [token];
    return await executeQuery(sql, values);
}

const spDeleteToken = async (token) => {
    const sql = 'CALL sp_DeleteToken(?)';
    const values = [token];
    return await executeQuery(sql, values);
}

const spGetUserAssets = async (JSON) => {
    const sql = 'CALL sp_getUserAssets(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
}

const spBuyAssets = async (JSON) => {
    const sql = 'CALL sp_buyAsset(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
}

const spGetAssetsStation = async (JSON) => {
    const sql = 'CALL sp_getAssetsStation(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
}

const spGetPlayerStockpiles = async (JSON) => {
    const sql = 'CALL sp_getPlayerStockpiles(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
}

const spGetPlayerNeeds = async (JSON) => {
    const sql = 'CALL sp_getPlayerNeeds(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
}


module.exports = {
    executeQuery,
    spLogin,
    spRegister,
    spGetPlayer,
    spGetPlayers,
    spGetSalt,
    spGetWorld,
    spGetWorlds,
    spGetAsset,
    spGetAssets,
    spCreateAsset,
    spGetGood,
    spGetGoods,
    spGetIndustries,
    spGetIndustry,
    spCreateIndustry,
    spCreateRailway,
    spGetRailway,
    spGetRailways,
    spCreateStation,
    spGetStation,
    spGetStations,
    spCreateTrain,
    spGetTrain,
    spGetTrains,
    spCheckTokenExists,
    spDeleteToken,
    spGetUserAssets,
    spBuyAssets,
    spGetAssetsStation,
    spGetPlayerStockpiles,
    spGetPlayerNeeds
};