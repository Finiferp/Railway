DELIMITER //
DROP PROCEDURE IF EXISTS sp_createAsset;
CREATE PROCEDURE sp_createAsset(IN json_data JSON)
BEGIN
    DECLARE input_type VARCHAR(50);
    DECLARE input_name VARCHAR(450);
    DECLARE input_position_x INT;
    DECLARE input_position_y INT;
    DECLARE input_world_id INT;
    DECLARE input_business VARCHAR(450);
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE new_asset_id INT;

    -- Extracting data from JSON input
    SET input_type = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.type'));
    SET input_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.name'));
    SET input_position_x = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.position.x'));
    SET input_position_y = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.position.y'));
	SET input_world_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.worldId'));
    -- Check if the asset name is unique
    IF EXISTS (SELECT 1 FROM Asset WHERE name = input_name) THEN
        -- Asset name already exists, set response code to 409 (Conflict)
        SET response_code = 409;
        SET response_message = 'Asset name already exists';
    ELSE
        -- Validate input type
        IF NOT (input_type IN ('TOWN', 'RURALBUSINESS')) THEN
            -- Invalid input type, set response code to 400 (Bad Request)
            SET response_code = 400;
            SET response_message = 'Invalid asset type';
        ELSE
			IF input_type = 'TOWN' THEN
				INSERT INTO Asset (name, type, population, level, stockpileMax, idWorld_FK, position)
				VALUES (input_name, input_type, 500, 1, 10, input_world_id, POINT(input_position_x, input_position_y));
                           
				SET new_asset_id = LAST_INSERT_ID();
				CALL sp_changeNeeds(new_asset_id,1,1);
				
			ELSE
                SET input_business = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.business'));

				INSERT INTO Asset (name, type, population, level, stockpileMax, idWorld_FK, position)
				VALUES (input_name, input_type, 0, 0, 0, input_world_id, POINT(input_position_x, input_position_y));
                CALL sp_createBusiness(input_business,LAST_INSERT_ID());
			END IF;


            -- Set response code to 200 (OK) and return the created asset
            SET response_code = 200;
            SET response_message = 'Asset created successfully';
        END IF;
    END IF;

    -- Returning the JSON response
    IF response_code = 200 THEN
        SELECT JSON_OBJECT(
            'status_code', response_code,
            'message', response_message,
            'asset', JSON_OBJECT(
                'id', new_asset_id,
                'name', input_name,
                'type', input_type,
                'position', JSON_OBJECT('x', input_position_x, 'y', input_position_y)
            )
        ) AS 'result';
    ELSE
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
    END IF;

END //

DELIMITER ;
