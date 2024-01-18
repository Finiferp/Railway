DELIMITER //

DROP PROCEDURE IF EXISTS sp_buyAsset;
CREATE PROCEDURE sp_buyAsset(IN json_input JSON)
BEGIN
    DECLARE user_id INT;
    DECLARE asset_id INT;
    DECLARE owner_id INT;
    DECLARE player_funds BIGINT;
    DECLARE asset_price INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE v_JSONSchema JSON;
    SET v_JSONSchema = '{"type": "object",
                            "properties": {
                                "userId": {"type": "number"}, 
                                "assetId": {"type": "number"} 
                            }, 
                            "required": ["userId", "assetId"] 
                        }';

    IF NOT JSON_SCHEMA_VALID(v_JSONSchema, json_input) THEN
        SET response_code = 400;
        SET response_message = 'Invalid JSON format or structure';
        SELECT JSON_OBJECT(
            'status_code', response_code,
            'message', response_message
        ) AS 'result';
    ELSE
    
        SET user_id = JSON_UNQUOTE(JSON_EXTRACT(json_input, '$.userId'));
        SET asset_id = JSON_UNQUOTE(JSON_EXTRACT(json_input, '$.assetId'));

        SELECT idOwner_FK , cost INTO owner_id, asset_price
        FROM Asset
        WHERE idAsset_PK = asset_id;

        SELECT p.funds INTO player_funds
        FROM Player p
        WHERE p.idPlayer_PK = user_id;


        IF owner_id IS NULL AND player_funds >= asset_price THEN
            UPDATE Asset
            SET idOwner_FK = user_id
            WHERE idAsset_PK = asset_id;

            CALL sp_deleteFunds(asset_price, user_id);
            SET response_code = 200;
            SET response_message = 'Asset owner updated successfully';
        ELSE
            SET response_code = 400;
            SET response_message = 'Invalid operation. Check player funds or asset ownership.';
        END IF;

        -- Returning the JSON response
        IF response_code = 200 THEN
            SELECT JSON_OBJECT(
                'status_code', response_code,
                'message', response_message,
                'asset', JSON_OBJECT(
                    'idAsset_PK', idAsset_PK,
                    'name', name,
                    'type', type,
                    'population', population,
                    'level', level,
                    'stockpileMax', stockpileMax,
                    'idWorld_FK', idWorld_FK,
                    'position', position,
                    'idOwner_FK', idOwner_FK,
                    'cost', cost
                )
            ) AS 'result'
            FROM Asset 
            WHERE idAsset_PK = asset_id;
        ELSE
            SELECT JSON_OBJECT(
                'status_code', response_code,
                'message', response_message
            ) AS 'result';
        END IF;
    END IF;
END //

DELIMITER ;
