DELIMITER //

DROP PROCEDURE IF EXISTS sp_getPlayerIndustries;

CREATE PROCEDURE sp_getPlayerIndustries(IN inputJSON JSON)
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE data JSON;
    DECLARE input_user_id INT;

    -- Extracting userId from input JSON
    SET input_user_id = JSON_UNQUOTE(JSON_EXTRACT(inputJSON, '$.userId'));

    -- Selecting player's industries grouped by asset
    SET data = (
        SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'asset_id', a.idAsset_PK,
                    'asset_name', a.name,
                    'industries', (
                        SELECT JSON_ARRAYAGG(
                                JSON_OBJECT(
                                    'industry_id', i.idIndustry_PK,
                                    'industry_name', i.name,
                                    'warehouse_capacity', i.warehouseCapacity,
                                    'industry_type', i.type,
                                    'produced_good_name', g.name,
                                    'cost', i.cost,
                                    'upkeep_cost', i.upkeepcost
                                )
                            )
                        FROM Industry i
                        LEFT JOIN Good g ON i.idGood_Produce_FK = g.idGood_PK
                        WHERE a.idAsset_PK = i.idAsset_FK
                    )
                )
            )
        FROM Asset a
        WHERE a.idOwner_FK = input_user_id
    );

    -- Handling response based on the data
    IF data IS NULL OR data = '[]' THEN
        -- No industries found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No industries found for the player';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Industries retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', data) AS 'result';

END //

DELIMITER ;
