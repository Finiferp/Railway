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


// Function to execute a query with or without parameters
const executeQuery = async (sql, values) => {
    const connection = await pool.getConnection();
    try {
        const [results] = await connection.execute(sql, values);
        return results;
    } finally {
        connection.release();
    }
};

// Stored procedure for user login
const spLogin = async (JSON) => {
    const sql = 'CALL sp_Login(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

// Stored procedure for user registration
const spRegister = async (JSON) => {
    const sql = 'CALL sp_Register(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

// Stored procedure to get a single player
const spGetPlayer = async (JSON) => {
    const sql = 'CALL sp_getPlayer(?)';
    const values = [JSON];
    return await executeQuery(sql, values);
};

// Stored procedure to get all players
const spGetPlayers = async () => {
    const sql = 'CALL sp_getPlayers()';
    return await executeQuery(sql);
};

const spGetSalt = async (username) => {
    const sql = 'CALL sp_getSalt(?)';
    const values = [username];
    return await executeQuery(sql,values);
};



module.exports = {
    executeQuery,
    spLogin,
    spRegister,
    spGetPlayer,
    spGetPlayers,
    spGetSalt,


};