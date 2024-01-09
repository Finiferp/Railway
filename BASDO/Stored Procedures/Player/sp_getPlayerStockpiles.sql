DELIMITER //

DROP PROCEDURE IF EXISTS sp_getPlayerStockpiles;
CREATE PROCEDURE sp_getPlayerStockpiles(IN inputJSON JSON)
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE data JSON;
    DECLARE input_user_id INT;
    DECLARE v_JSONSchema JSON;
    SET v_JSONSchema = '{
        "type": "object",
        "properties": {
            "userId": {"type": "number"}
        },
        "required": ["userId"]
    }';


    
    IF NOT (JSON_SCHEMA_VALID(v_JSONSchema, inputJSON)) THEN
        SET response_code = 400;
        SET response_message = 'Invalid JSON format or structure for asset_id';
        SELECT JSON_OBJECT(
            'status_code', response_code,
            'message', response_message
        ) AS 'result';
    ELSE    
        SET input_user_id = JSON_UNQUOTE(JSON_EXTRACT(inputJSON, '$.userId'));
        
        SET data = (
            SELECT
            JSON_ARRAYAGG(
                JSON_OBJECT(
                    'asset_id', asset_id,
                    'asset_name', asset_name,
                    'goods', goods
                )
            ) AS assets_with_goods
            FROM (
                SELECT a.idAsset_PK AS asset_id,
                    a.name AS asset_name,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'good_name', g.name,
                            'quantity', s.quantity
                        )
                    ) AS goods
                FROM Asset a
                JOIN Stockpiles s ON a.idAsset_PK = s.idAsset_Stockpiles_PKFK
                JOIN Good g ON s.idGoodt_Stockpiles_PKFK = g.idGood_PK
                WHERE a.type = 'TOWN' AND a.idOwner_FK = input_user_id
                GROUP BY a.idAsset_PK, a.name
            ) AS grouped_data
        );

        IF data IS NULL OR data = '[]' THEN
            -- No players found, set response code to 404 (Not Found)
            SET response_code = 404;
            SET response_message = 'No Stock found';
        ELSE
            -- Set response code to 200 (OK)
            SET response_code = 200;
            SET response_message = 'Stock retrieved successfully';
        END IF;

        -- Returning the JSON response
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', data) AS 'result';
    END IF;


END //

DELIMITER ;
