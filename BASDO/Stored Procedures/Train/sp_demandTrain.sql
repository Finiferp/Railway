DELIMITER //
DROP PROCEDURE IF EXISTS sp_demandTrain;
CREATE PROCEDURE sp_demandTrain(IN input_json JSON)
BEGIN
    DECLARE asset_from_id INT;
    DECLARE asset_to_id INT;
    DECLARE railway_id INT;
    DECLARE good_id INT;
    DECLARE amount_to_transport INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(450);
    DECLARE stockpile_quantity INT;
    DECLARE stockpile_max INT;
    DECLARE wagons_needed INT;
    DECLARE last_train_id INT;
    DECLARE i INT;

    SET asset_from_id = JSON_UNQUOTE(JSON_EXTRACT(input_json, '$.assetFromId'));
    SET asset_to_id = JSON_UNQUOTE(JSON_EXTRACT(input_json, '$.assetToId'));
    SET railway_id = JSON_UNQUOTE(JSON_EXTRACT(input_json, '$.railwayId'));
    SET good_id = JSON_UNQUOTE(JSON_EXTRACT(input_json, '$.goodId'));
    SET amount_to_transport = JSON_UNQUOTE(JSON_EXTRACT(input_json, '$.amount'));
     IF (SELECT type FROM Asset WHERE idAsset_PK = asset_to_id) = 'TOWN' THEN
        SELECT SUM(quantity), stockpileMax INTO stockpile_quantity, stockpile_max
        FROM Stockpiles JOIN Asset a ON idAsset_Stockpiles_PKFK = idAsset_PK
        WHERE idAsset_Stockpiles_PKFK = asset_to_id
        GROUP BY idAsset_Stockpiles_PKFK;

        IF stockpile_quantity + amount_to_transport <= stockpile_max THEN
            SET wagons_needed = LEAST(CEIL(amount_to_transport / stockpile_max), 10);

            INSERT INTO Train (name, idRailway_FK, idAsset_Starts_FK, idAsset_Destines_FK)
            VALUES ('New Train', railway_id, asset_from_id, asset_to_id);

            SET last_train_id = LAST_INSERT_ID();

            WHILE i < wagons_needed DO
                INSERT INTO Wagon (idTrain_FK, idGood_Transport_FK)
                VALUES (last_train_id, good_id); 
                SET i = i + 1;
            END WHILE;

            SET response_code = 200;
            SET response_message = 'Train and wagons created successfully';
        ELSE
            SET response_code = 400;
            SET response_message = 'Not enough stockpile space in the destination asset for the specified amount of goods';
        END IF;
    ELSE
        SET response_code = 400;
        SET response_message = 'The second asset must be of type "RURALBUSINESS"';
    END IF;

    SELECT JSON_OBJECT(
        'status_code', response_code,
        'message', response_message
    ) AS 'result';

END //

DELIMITER ;