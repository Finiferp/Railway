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
    spCreateIndustry
};