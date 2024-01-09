DELIMITER //
DROP PROCEDURE IF EXISTS sp_getWorldAssets;
CREATE PROCEDURE sp_getWorldAssets(IN inputJson JSON)
BEGIN
    DECLARE worldId INT;
    DECLARE assetList JSON;
    DECLARE responseCode INT DEFAULT 200; 
    DECLARE responseMessage VARCHAR(255) DEFAULT 'Success';
    DECLARE v_JSONSchema JSON;
    SET v_JSONSchema = '{
        "type": "object",
        "properties": {
            "worldId": {"type": "number"}
        },
        "required": ["worldId"]
    }';


    
    IF NOT (JSON_SCHEMA_VALID(v_JSONSchema, inputJson)) THEN
        SET responseCode = 400;
        SET responseMessage = 'Invalid JSON format or structure for asset_id';
        SELECT JSON_OBJECT(
            'status_code', responseCode,
            'message', responseMessage
        ) AS 'result';
    ELSE    

        SET worldId = JSON_UNQUOTE(JSON_EXTRACT(inputJson, '$.worldId'));

        BEGIN
            DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET responseCode = 500;
                SET responseMessage = 'Error in the stored procedure';
            END;

            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'idAsset_PK', A.idAsset_PK,
                    'name', A.name,
                    'type', A.type,
                    'population', A.population,
                    'level', A.level,
                    'stockpileMax', A.stockpileMax,
                    'position', ST_AsText(A.position),
                    'idOwner_FK', A.idOwner_FK,
                    'cost', A.cost,
                    'goods', CASE
                                WHEN A.type = 'RURALBUSINESS' THEN
                                    (SELECT JSON_ARRAYAGG(
                                        JSON_OBJECT(
                                            'idGood_PK', G.idGood_PK,
                                            'name', G.name
                                        )
                                    ) FROM Makes M
                                    JOIN Good G ON M.idGood_Makes_PKFK = G.idGood_PK
                                    WHERE M.idAsset_Makes_PKFK = A.idAsset_PK)
                                ELSE NULL
                            END
                ) 
            ) INTO assetList
            FROM Asset A
            WHERE A.idWorld_FK = worldId;
        END;

        SELECT JSON_OBJECT(
            'status_code', responseCode,
            'message', responseMessage,
            'data', assetList
        ) AS result;
    END IF;
END //
DELIMITER ;
