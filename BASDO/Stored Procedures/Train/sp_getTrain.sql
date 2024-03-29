DELIMITER //
DROP PROCEDURE IF EXISTS sp_getTrain;
CREATE PROCEDURE sp_getTrain(IN json_data JSON)
BEGIN
    DECLARE input_train_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE train_data JSON;
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
    
        SET input_train_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.id'));

        -- Checking if the train ID exists
        IF NOT EXISTS (SELECT 1 FROM Train WHERE idTrain_PK = input_train_id) THEN
            -- Train ID does not exist, set response code to 404 (Not Found)
            SET response_code = 404;
            SET response_message = 'Train not found';
            SET train_data = NULL; -- Set train_data to NULL when train is not found
        ELSE
            -- Retrieve train data for the given train ID
            SET train_data = (
                SELECT JSON_OBJECT(
                    'id', idTrain_PK,
                    'name', name,
                    'traveledDistance', traveledDistance,
                    'operationalCost', operationalCost,
                    'railwayId', idRailway_FK,
                    'idAsset_Starts_FK', idAsset_Starts_FK,
                    'idAsset_Destines_FK', idAsset_Destines_FK
                )
                FROM Train
                WHERE idTrain_PK = input_train_id
            );

            -- Set response code to 200 (OK)
            SET response_code = 200;
            SET response_message = 'Train retrieved successfully';
        END IF;

        -- Returning the JSON response
        IF response_code = 200 THEN
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', train_data) AS 'result';
        ELSE
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
        END IF;
    END IF;

END //
DELIMITER ;