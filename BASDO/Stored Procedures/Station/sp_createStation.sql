DELIMITER //
DROP PROCEDURE IF EXISTS sp_createStation;
CREATE PROCEDURE sp_createStation(IN json_data JSON)
BEGIN
    DECLARE input_name VARCHAR(450);
    DECLARE input_asset_id INT;
    DECLARE response_code INT;
    DECLARE userId INT;
    DECLARE cost INT;
    DECLARE response_message VARCHAR(255);
    DECLARE new_station_id INT;
    DECLARE v_JSONSchema JSON;
        SET v_JSONSchema = '{
        "type": "object",
        "properties": {
            "name": {"type": "string"},
            "assetId": {"type": "number"}
        },
        "required": ["name", "assetId"]
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
        SET input_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.name'));
        SET input_asset_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.assetId'));

        -- Check if the asset ID exists
        IF NOT EXISTS (SELECT 1 FROM Asset WHERE idAsset_PK = input_asset_id) THEN
            -- Asset ID does not exist, set response code to 404 (Not Found)
            SET response_code = 404;
            SET response_message = 'Asset not found';
        ELSE
            -- Check if a station already exists for the given asset
            IF EXISTS (SELECT 1 FROM Station WHERE idAsset_FK = input_asset_id) THEN
                -- Station for the asset already exists, set response code to 409 (Conflict)
                SET response_code = 409;
                SET response_message = 'Station already exists for the asset';
            ELSE
                -- Check if the station name is unique
                IF EXISTS (SELECT 1 FROM Station WHERE name = input_name) THEN
                    -- Station name already exists, set response code to 409 (Conflict)
                    SET response_code = 409;
                    SET response_message = 'Station name already exists';
                ELSE
                    -- Insert the new station into the Station table
                    INSERT INTO Station (name, idAsset_FK)
                    VALUES (input_name, input_asset_id); -- Assuming default values for cost and operationCost

                    -- Get the ID of the newly inserted station
                    SET new_station_id = LAST_INSERT_ID();

                    -- Set response code to 200 (OK) and return the created station
                    SET response_code = 200;
                    SET response_message = 'Station created successfully';

                    
                    SELECT s.cost, a.idOwner_FK INTO cost, userId
                    FROM Asset a JOIN Station s
                    WHERE idAsset_PK = idAsset_FK AND idStation_PK =  new_station_id;
                    CALL sp_deleteFunds(cost, userId);
                END IF;
            END IF;
        END IF;

        -- Returning the JSON response
        IF response_code = 200 THEN
            SELECT JSON_OBJECT(
                'status_code', response_code,
                'message', response_message,
                'station', JSON_OBJECT(
                    'id', new_station_id,
                    'name', input_name,
                    'assetId', input_asset_id
                )
            ) AS 'result';
        ELSE
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
        END IF;
    END IF;

END //

DELIMITER ;
