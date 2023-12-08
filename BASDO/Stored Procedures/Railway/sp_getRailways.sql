DELIMITER //
DROP PROCEDURE IF EXISTS sp_getRailways;
CREATE PROCEDURE sp_getRailways()
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE railways_data JSON;

    -- Retrieve all railway data
    SET railways_data = (
        SELECT CONCAT('[', IFNULL(
            GROUP_CONCAT(
                JSON_OBJECT(
                    'id', idRailway_PK,
                    'distance', distance
                ) ORDER BY idRailway_PK
            ), '[]'
        ), ']') AS railways
        FROM Railway
    );

    -- Check if any railways exist
    IF railways_data IS NULL OR railways_data = '[]' THEN
        -- No railways found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No railways found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Railways retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', railways_data) AS 'result';

END //

DELIMITER ;