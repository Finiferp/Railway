DELIMITER //
DROP PROCEDURE IF EXISTS sp_getStations;
CREATE PROCEDURE sp_getStations()
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE stations_data JSON;

    -- Retrieve all station data
    SET stations_data = (
        SELECT CONCAT('[', IFNULL(
            GROUP_CONCAT(
                JSON_OBJECT(
                    'id', idStation_PK,
                    'name', name,
                    'cost', cost,
                    'operationCost', operationCost,
                    'assetId', idAsset_FK
                ) ORDER BY idStation_PK
            ), '[]'
        ), ']') AS stations
        FROM Station
    );

    -- Check if any stations exist
    IF stations_data IS NULL OR stations_data = '[]' THEN
        -- No stations found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No stations found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Stations retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', stations_data) AS 'result';

END //

DELIMITER ;