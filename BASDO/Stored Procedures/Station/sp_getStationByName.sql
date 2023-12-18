DELIMITER //
DROP PROCEDURE IF EXISTS sp_getStationByName;
CREATE PROCEDURE sp_getStationByName(IN json_data JSON)
BEGIN
    DECLARE input_station_name VARCHAR(255);
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE station_data JSON;

    -- Extracting data from JSON input
    SET input_station_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.station_name'));

    -- Retrieve station data for the given station name
    SET station_data = (
        SELECT JSON_OBJECT(
            'id', idStation_PK,
            'name', name,
            'cost', cost,
            'operationCost', operationCost,
            'idAsset_FK', idAsset_FK
        ) AS station
        FROM Station
        WHERE name = input_station_name
    );

    -- Check if the station name exists
    IF station_data IS NULL THEN
        -- Station name does not exist, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'Station not found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Station retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', station_data) AS 'result';

END //

DELIMITER ;
