DELIMITER //
DROP PROCEDURE IF EXISTS sp_getGood;
CREATE PROCEDURE sp_getGood(IN json_data JSON)
BEGIN
    DECLARE input_good_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE good_data JSON;
    DECLARE v_JSONSchema JSON;

    SET v_JSONSchema = '{
        "type": "object",
        "properties": {
            "id": {"type": "number"}
        },
        "required": ["id"],
    }';
    IF NOT (JSON_SCHEMA_VALID(v_JSONSchema, json_data)) THEN
        SET response_code = 400;
        SET response_message = 'Invalid JSON format or structure for asset_id';
        SELECT JSON_OBJECT(
            'status_code', response_code,
            'message', response_message
        ) AS 'result';
    ELSE
        
        SET input_good_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.id'));

        -- Checking if the good ID exists
        IF NOT EXISTS (SELECT 1 FROM Good WHERE idGood_PK = input_good_id) THEN
            -- Good ID does not exist, set response code to 404 (Not Found)
            SET response_code = 404;
            SET response_message = 'Good not found';
            SET good_data = NULL; -- Set good_data to NULL when good is not found
        ELSE
            -- Retrieve good data for the given good ID
            SET good_data = (
                SELECT JSON_OBJECT(
                    'id', idGood_PK,
                    'name', name
                )
                FROM Good
                WHERE idGood_PK = input_good_id
            );

            -- Set response code to 200 (OK)
            SET response_code = 200;
            SET response_message = 'Good retrieved successfully';
        END IF;

        -- Returning the JSON response
        IF response_code = 200 THEN
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', good_data) AS 'result';
        ELSE
            SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
        END IF;
    END IF;

END //
DELIMITER ;