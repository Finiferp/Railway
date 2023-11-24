DELIMITER //
DROP PROCEDURE IF EXISTS sp_getPlayer;
CREATE PROCEDURE sp_getPlayer(IN json_data JSON)
BEGIN
    DECLARE input_user_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE user_data JSON;

    -- Extracting data from JSON input
    SET input_user_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.userId'));

    -- Checking if the user ID exists
    IF NOT EXISTS (SELECT 1 FROM Player WHERE idPlayer_PK = input_user_id) THEN
        -- User ID does not exist, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'User not found';
    ELSE
        -- Retrieve user data for the given user ID
        SET user_data = (
            SELECT JSON_OBJECT(
                'userId', idPlayer_PK,
                'username', username,
                'worldId', idWorld_FK
            )
            FROM Player
            WHERE idPlayer_PK = input_user_id
        );

        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'User retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', user_data) AS 'result';

END //

DELIMITER ;
