DELIMITER //
DROP PROCEDURE IF EXISTS sp_getWorld;
CREATE PROCEDURE sp_getWorld(IN json_data JSON)
BEGIN
    DECLARE input_world_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE world_data JSON;
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
    
        SET input_world_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.id'));

        -- Checking if the world ID exists
        IF NOT EXISTS (SELECT 1 FROM World WHERE idWorld_PK = input_world_id) THEN
            -- World ID does not exist, set response code to 404 (Not Found)
            SET response_code = 404;
            SET response_message = 'World not found';
            SET world_data = NULL; -- Set world_data to NULL when world is not found
        ELSE
            -- Retrieve world data for the given world ID
            SET world_data = (
                SELECT JSON_OBJECT(
                    'id', idWorld_PK,
                    'creationDate', creationDate
                )
                FROM World
                WHERE idWorld_PK = input_world_id
            );

            -- Set response code to 200 (OK)
            SET response_code = 200;
            SET response_message = 'World retrieved successfully';
        END IF;

        -- Returning the JSON response
        IF response_code = 200 THEN
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', world_data) AS 'result';
        ELSE
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
        END IF;
    END IF;

END //

DELIMITER ;
