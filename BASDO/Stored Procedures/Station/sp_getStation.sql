DELIMITER //
DROP PROCEDURE IF EXISTS sp_getStation;
CREATE PROCEDURE sp_getStation(IN json_data JSON)
BEGIN
    DECLARE input_station_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE station_data JSON;
    DECLARE v_JSONSchema JSON;
    SET v_JSONSchema = '{
        "type": "object",
        "properties": {
            "id": {"type": "number"}
        },
        "required": ["id"]
    }';

    IF NOT (JSON_SCHEMA_VALID(v_JSONSchema, json_data)) THEN
        SET response_code = 400;
        SET response_message = 'Invalid JSON format or structure for asset_id';
        SELECT JSON_OBJECT(
            'status_code', response_code,
            'message', response_message
        ) AS 'result';
    ELSE    
        -- Extracting data from JSON input
        SET input_station_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.id'));

        -- Checking if the station ID exists
        IF NOT EXISTS (SELECT 1 FROM Station WHERE idStation_PK = input_station_id) THEN
            -- Station ID does not exist, set response code to 404 (Not Found)
            SET response_code = 404;
            SET response_message = 'Station not found';
            SET station_data = NULL; -- Set station_data to NULL when station is not found
        ELSE
            -- Retrieve station data for the given station ID
            SET station_data = (
                SELECT JSON_OBJECT(
                    'id', idStation_PK,
                    'name', name,
                    'cost', cost,
                    'operationCost', operationCost,
                    'assetId', idAsset_FK
                )
                FROM Station
                WHERE idStation_PK = input_station_id
            );

            -- Set response code to 200 (OK)
            SET response_code = 200;
            SET response_message = 'Station retrieved successfully';
        END IF;

        -- Returning the JSON response
        IF response_code = 200 THEN
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', station_data) AS 'result';
        ELSE
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
        END IF;
    END IF;

END //