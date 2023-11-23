DELIMITER //
DROP PROCEDURE IF EXISTS sp_createAsset;
CREATE PROCEDURE sp_createAsset(IN json_data JSON)
BEGIN
    DECLARE input_type VARCHAR(50);
    DECLARE input_name VARCHAR(450);
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE new_asset_id INT;

    -- Extracting data from JSON input
    SET input_type = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.type'));
    SET input_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.name'));

    -- Check if the asset name is unique
    IF EXISTS (SELECT 1 FROM Asset WHERE name = input_name) THEN
        -- Asset name already exists, set response code to 409 (Conflict)
        SET response_code = 409;
        SET response_message = 'Asset name already exists';
    ELSE
        -- Validate input type
        IF NOT (input_type IN ('Town', 'RuralBusiness')) THEN
            -- Invalid input type, set response code to 400 (Bad Request)
            SET response_code = 400;
            SET response_message = 'Invalid asset type';
        ELSE
            -- Insert the new asset into the Asset table
            INSERT INTO Asset (name, type, population, level, stockpile, idWorld_FK)
            VALUES (input_name, input_type, 0, 1, 0, 1); -- Assuming default values for population, level, and stockpile

            -- Get the ID of the newly inserted asset
            SET new_asset_id = LAST_INSERT_ID();

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
                'type', input_type
            )
        ) AS 'result';
    ELSE
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
    END IF;

END //

DELIMITER ;
