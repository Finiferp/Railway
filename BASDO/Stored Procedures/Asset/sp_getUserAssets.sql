DELIMITER //

DROP PROCEDURE IF EXISTS sp_getUserAssets;

CREATE PROCEDURE sp_getUserAssets(IN json_data JSON)
BEGIN
    DECLARE input_user_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE assets_data JSON;

    SET input_user_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.id'));

    IF NOT EXISTS (SELECT 1 FROM Player WHERE idPlayer_PK = input_user_id) THEN
        SET response_code = 404;
        SET response_message = 'User not found';
    ELSE
        SET assets_data = (
            SELECT IFNULL(
                JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'assetId', idAsset_PK,
                        'name', name,
                        'type', type,
                        'population', population,
                        'level', level,
                        'stockpileMax', stockpileMax,
                        'worldId', idWorld_FK,
                        'position', ST_AsText(position),
                        'cost', cost
                    )
                ),
                JSON_OBJECT('message', 'You have no Assets')
            )
            FROM Asset
            WHERE idOwner_FK = input_user_id
        );

        IF assets_data IS NULL THEN
            SET response_code = 204; -- No Content
            SET response_message = 'No Assets for the user';
        ELSE
            SET response_code = 200;
            SET response_message = 'Assets retrieved successfully';
        END IF;
    END IF;

    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', assets_data) AS 'result';

END //

DELIMITER ;
