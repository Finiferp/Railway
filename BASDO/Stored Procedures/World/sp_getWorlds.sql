DELIMITER //
DROP PROCEDURE IF EXISTS sp_getWorldAssets;
CREATE PROCEDURE sp_getWorldAssets(IN inputJson JSON)
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE worlds_data JSON;

    -- Retrieve all world data
    SET worlds_data = (
        SELECT CONCAT('[', IFNULL(
            GROUP_CONCAT(
                JSON_OBJECT(
                    'id', idWorld_PK,
                    'creationDate', creationDate
                ) ORDER BY idWorld_PK
            ), '[]'
        ), ']') AS worlds
        FROM World
    );

    -- Check if any worlds exist
    IF worlds_data IS NULL OR worlds_data = '[]' THEN
        -- No worlds found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No worlds found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Worlds retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', worlds_data) AS 'result';

END //
DELIMITER ;
