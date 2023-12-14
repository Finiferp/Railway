DELIMITER //

DROP PROCEDURE IF EXISTS sp_createTrain;

CREATE PROCEDURE sp_createTrain(IN json_data JSON)
BEGIN
    DECLARE input_name VARCHAR(450);
    DECLARE input_idRailway INT;
    DECLARE input_idAsset_Starts INT;
    DECLARE input_idAsset_Destines INT;
    DECLARE input_willReturnWithGoods TINYINT;
    DECLARE new_train_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE wagon_count INT;
    DECLARE i INT;
    DECLARE random_need INT;
    DECLARE producing_industry_id INT;
    DECLARE warehouse_quantity INT;
    DECLARE town_makes_good INT;
    DECLARE random_load INT;
    DECLARE cost INT;
    DECLARE userId INT;
    -- Extracting data from JSON input
    SET input_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.name'));
    SET input_idRailway = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.idRailway'));
    SET input_idAsset_Starts = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.idAsset_Starts'));
    SET input_idAsset_Destines = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.idAsset_Destines'));
    SET input_willReturnWithGoods = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.willReturnWithGoods'));
    -- Create a new train
    INSERT INTO `Train` (`name`, `idRailway_FK`, `idAsset_Starts_FK`, `idAsset_Destines_FK`)
    VALUES (input_name, input_idRailway, input_idAsset_Starts, input_idAsset_Destines);

    SET new_train_id = LAST_INSERT_ID();

    -- Randomly assign loads to wagons
    SET wagon_count = 10; -- Maximum number of wagons
    SET i = 1;

    WHILE i <= wagon_count DO
        -- Randomly select a need from the destination town
        SET random_need = (SELECT `idGood_Needs_PKFK`
                            FROM `Needs`
                            WHERE `idAsset_Needs_PKFK` = input_idAsset_Destines
                            ORDER BY RAND()
                            LIMIT 1);

        -- Check if there is an industry producing the selected need
        SET producing_industry_id = (SELECT `idIndustry_PK`
                                      FROM `Industry`
                                      WHERE `idAsset_FK` = input_idAsset_Destines
                                        AND `idGood_Produce_FK` = random_need);

        -- If there is a producing industry, satisfy the need from its warehouse
        IF producing_industry_id IS NOT NULL THEN
            SET warehouse_quantity = (SELECT `quantity`
                                       FROM `Stockpiles`
                                       WHERE `idAsset_Stockpiles_PKFK` = input_idAsset_Destines
                                         AND `idGoodt_Stockpiles_PKFK` = random_need);

            -- Subtract the need from the warehouse if enough quantity is available
            IF warehouse_quantity IS NOT NULL AND warehouse_quantity > 0 THEN
                INSERT INTO `Wagon` (`idTrain_FK`, `idGood_Transport_FK`)
                VALUES (new_train_id, random_need);

                -- Update the warehouse quantity
                UPDATE `Stockpiles`
                SET `quantity` = GREATEST(0, warehouse_quantity - 1)
                WHERE `idAsset_Stockpiles_PKFK` = input_idAsset_Destines
                  AND `idGoodt_Stockpiles_PKFK` = random_need;
            END IF;
        ELSE
            -- If there is no producing industry, check if the town itself makes the needed good
            SET town_makes_good = (SELECT `idGood_Makes_PKFK`
                                    FROM `Makes`
                                    WHERE `idAsset_Makes_PKFK` = input_idAsset_Destines
                                      AND `idGood_Makes_PKFK` = random_need);

            -- If the town makes the needed good, satisfy the need from its production
            IF town_makes_good IS NOT NULL THEN
                INSERT INTO `Wagon` (`idTrain_FK`, `load`)
                VALUES (new_train_id, random_need);
            END IF;
        END IF;

        -- If the wagon is still empty, randomly decide to load mail or passengers
        IF (SELECT COUNT(*) FROM `Wagon` WHERE `idTrain_FK` = new_train_id) < 10 THEN
            SET random_load = FLOOR(1 + RAND() * 2); -- 1: mail, 2: passengers

            INSERT INTO `Wagon` (`idTrain_FK`, `idGood_Transport_FK`)
            VALUES (new_train_id, CASE WHEN random_load = 1 THEN 24 ELSE 25 END);
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Set response code and message
    SET response_code = 201;
    SET response_message = 'Train created successfully';

    SELECT t.cost, a.idOwner_FK INTO cost, userId
    FROM Train t JOIN Asset a
    WHERE idAsset_PK = input_idAsset_Starts
    LIMIT 1;
    CALL sp_deleteFunds(cost, userId);
    -- Return the JSON response
    SELECT JSON_OBJECT('status_code', response_code,
                       'message', response_message,
                       'train', JSON_OBJECT('id', new_train_id,
                                            'name', input_name,
                                            'idRailway', input_idRailway,
                                            'idAsset_Starts', input_idAsset_Starts,
                                            'idAsset_Destines', input_idAsset_Destines,
                                            'willReturnWithGoods', input_willReturnWithGoods)) AS 'result';
END;

DELIMITER ;
