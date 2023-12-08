DELIMITER //
DROP PROCEDURE IF EXISTS sp_getRailway;
CREATE PROCEDURE sp_getRailway(IN json_data JSON)
BEGIN
    DECLARE input_railway_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE railway_data JSON;

    -- Extracting data from JSON input
    SET input_railway_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.id'));

    -- Checking if the railway ID exists
    IF NOT EXISTS (SELECT 1 FROM Railway WHERE idRailway_PK = input_railway_id) THEN
        -- Railway ID does not exist, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'Railway not found';
        SET railway_data = NULL; -- Set railway_data to NULL when railway is not found
    ELSE
        -- Retrieve railway data for the given railway ID
        SET railway_data = (
            SELECT JSON_OBJECT(
                'id', idRailway_PK,
                'distance', distance
            )
            FROM Railway
            WHERE idRailway_PK = input_railway_id
        );

        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Railway retrieved successfully';
    END IF;

    -- Returning the JSON response
    IF response_code = 200 THEN
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', railway_data) AS 'result';
    ELSE
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
    END IF;

END //
DELIMITER ;