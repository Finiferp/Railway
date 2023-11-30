DELIMITER //
DROP PROCEDURE IF EXISTS sp_getAsset;
CREATE PROCEDURE sp_getAsset(IN json_data JSON)
BEGIN
    DECLARE input_asset_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE asset_data JSON;

    -- Extracting data from JSON input
    SET input_asset_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.id'));

    -- Checking if the asset ID exists
    IF NOT EXISTS (SELECT 1 FROM Asset WHERE idAsset_PK = input_asset_id) THEN
        -- Asset ID does not exist, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'Asset not found';
        SET asset_data = NULL; -- Set asset_data to NULL when asset is not found
    ELSE
        -- Retrieve asset data for the given asset ID
        SET asset_data = (
            SELECT JSON_OBJECT(
                'id', idAsset_PK,
                'name', name,
                'type', type,
                'population', population,
                'level', level,
                'stockpile', stockpile,
                'worldId', idWorld_FK,
                'position', position,
                'idOwner_FK', idOwner_FK
            )
            FROM Asset
            WHERE idAsset_PK = input_asset_id
        );

        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Asset retrieved successfully';
    END IF;

    -- Returning the JSON response
    IF response_code = 200 THEN
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', asset_data) AS 'result';
    ELSE
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
    END IF;

END //

DELIMITER ;
