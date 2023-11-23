DELIMITER //
DROP PROCEDURE IF EXISTS sp_getPlayers;
CREATE PROCEDURE sp_getPlayers()
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE players_data JSON;

    -- Retrieve all player data
    SET players_data = (
        SELECT CONCAT('[', GROUP_CONCAT(
            JSON_OBJECT(
                'userId', idPlayer_PK,
                'username', username,
                'worldId', idWorld_FK
            )
            ORDER BY idPlayer_PK
        ), ']') AS players
        FROM Player
    );

    -- Check if any players exist
    IF players_data IS NULL OR players_data = '[]' THEN
        -- No players found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No players found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Players retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', players_data) AS 'result';

END //

DELIMITER ;
