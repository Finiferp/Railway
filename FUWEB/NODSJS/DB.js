const mysql = require('mysql2/promise');
const DBConnectOpts = {
    host: '192.168.131.123',
    port: 3306,
    charset: 'utf8mb4',
    user: 'daniel',
    password: 'q1w2e3r4t5!',
    database: 'RailwayImperium',
};
const pool = mysql.createPool(DBConnectOpts);


const executeQuery = async (sql, values) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(sql, values);
        return rows;
    } finally {
        connection.release();
    }
};

// Example usage of the connection to fetch all players
const getAllPlayers = async () => {
    const sql = 'SELECT * FROM players';
    return await executeQuery(sql);
};

// Example usage of the connection to insert a new player
const insertPlayer = async (username, password, salt) => {
    const sql = 'INSERT INTO players (username, password, salt) VALUES (?, ?, ?)';
    const values = [username, password, salt];
    return await executeQuery(sql, values);
};

module.exports = {
    executeQuery,
    getAllPlayers,
    insertPlayer,
};