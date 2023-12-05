DELIMITER //
DROP PROCEDURE IF EXISTS sp_demandGoods;
CREATE PROCEDURE sp_demandGoods(IN input_json JSON)
BEGIN
    DECLARE asset_from_id INT;
    DECLARE asset_to_id INT;
    DECLARE railway_id INT;
    DECLARE good_id INT;
    DECLARE amount_to_transport INT;
    DECLARE response_code INT;
    DECLARE response_message INT;

    SET asset_from_id = JSON_UNQUOTE(JSON_EXTRACT(json_input, '$.assetFromId'));
    SET asset_to_id = JSON_UNQUOTE(JSON_EXTRACT(json_input, '$.assetToId'));
    SET railway_id = JSON_UNQUOTE(JSON_EXTRACT(json_input, '$.railwayId'));
    SET good_id = JSON_UNQUOTE(JSON_EXTRACT(json_input, '$.goodId'));
    SET amount_to_transport = JSON_UNQUOTE(JSON_EXTRACT(json_input, '$.amount'));

     IF (SELECT type FROM Asset WHERE idAsset_PK = asset_to_id) = 'RURALBUSINESS' THEN
        SELECT SUM(quantity) AS total_quantity, stockpileMax INTO @stockpile_quantity, @stockpile_max
        FROM Stockpiles
        WHERE idAsset_Stockpiles_PKFK = asset_to_id
        GROUP BY idAsset_Stockpiles_PKFK;

        IF @stockpile_quantity + amount_to_transport <= @stockpile_max THEN
            -- Calculate the number of wagons needed (up to 10 max)
            SET @wagons_needed = LEAST(CEIL(amount_to_transport / @stockpile_max), 10);

            -- Create the train
            INSERT INTO Train (name, idRailway_FK, idAsset_Starts_FK, idAsset_Destines_FK)
            VALUES ('New Train', railway_id, asset_from_id, asset_to_id);

            -- Get the ID of the last inserted train
            SET @last_train_id = LAST_INSERT_ID();

            -- Create wagons for the train
            WHILE @i < @wagons_needed DO
                INSERT INTO Wagon (idTrain_FK, idGood_Transport_FK)
                VALUES (@last_train_id, good_id); 
                SET @i = @i + 1;
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