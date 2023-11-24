DELIMITER //
DROP PROCEDURE IF EXISTS sp_getAssets;

CREATE PROCEDURE sp_getAssets()
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE assets_data JSON;

    -- Retrieve all asset data
    SET assets_data = (
        SELECT 
            CONCAT('[', 
                IFNULL(
                    GROUP_CONCAT(
                        JSON_OBJECT(
                            'id', idAsset_PK,
                            'name', name,
                            'type', type,
                            'population', population,
                            'level', level,
                            'stockpile', stockpile,
                            'worldId', idWorld_FK,
                            'position', position
                        ) ORDER BY idAsset_PK
                    ), 
                    '[]'
                ), 
                ']'
            ) AS assets
        FROM Asset
    );

    -- Check if any assets exist
    IF assets_data = '[]' THEN
        -- No assets found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No assets found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Assets retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', assets_data) AS 'result';
END //

DELIMITER ;
