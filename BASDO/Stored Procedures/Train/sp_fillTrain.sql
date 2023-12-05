DELIMITER //

DROP PROCEDURE IF EXISTS sp_fillTrain;

CREATE PROCEDURE sp_fillTrain(IN input_idAsset_Starts INT,input_idAsset_Destines INT, input_train_id INT)
BEGIN

    SET @wagon_count = 10; 
    SET @i = 1;

    WHILE @i <= @wagon_count DO
        -- Randomly select a need from the destination town
        SET @random_need = (SELECT `idGood_Needs_PKFK`
                            FROM `Needs`
                            WHERE `idAsset_Needs_PKFK` = input_idAsset_Destines
                            ORDER BY RAND()
                            LIMIT 1);

        -- Check if there is an industry producing the selected need
        SET @producing_industry_id = (SELECT `idIndustry_PK`
                                      FROM `Industry`
                                      WHERE `idAsset_FK` = input_idAsset_Destines
                                        AND `idGood_Produce_FK` = @random_need);

        -- If there is a producing industry, satisfy the need from its warehouse
        IF @producing_industry_id IS NOT NULL THEN
            SET @warehouse_quantity = (SELECT `quantity`
                                       FROM `Stockpiles`
                                       WHERE `idAsset_Stockpiles_PKFK` = input_idAsset_Destines
                                         AND `idGoodt_Stockpiles_PKFK` = @random_need);

            -- Subtract the need from the warehouse if enough quantity is available
            IF @warehouse_quantity IS NOT NULL AND @warehouse_quantity > 0 THEN
                INSERT INTO `Wagon` (`idTrain_FK`, `idGood_Transport_FK`)
                VALUES (input_train_id, @random_need);

                -- Update the warehouse quantity
                UPDATE `Stockpiles`
                SET `quantity` = GREATEST(0, @warehouse_quantity - 1)
                WHERE `idAsset_Stockpiles_PKFK` = input_idAsset_Destines
                  AND `idGoodt_Stockpiles_PKFK` = @random_need;
            END IF;
        ELSE
            -- If there is no producing industry, check if the town itself makes the needed good
            SET @town_makes_good = (SELECT `idGood_Makes_PKFK`
                                    FROM `Makes`
                                    WHERE `idAsset_Makes_PKFK` = input_idAsset_Destines
                                      AND `idGood_Makes_PKFK` = @random_need);

            -- If the town makes the needed good, satisfy the need from its production
            IF @town_makes_good IS NOT NULL THEN
                INSERT INTO `Wagon` (`idTrain_FK`, `load`)
                VALUES (input_train_id, @random_need);
            END IF;
        END IF;

        -- If the wagon is still empty, randomly decide to load mail or passengers
        IF (SELECT COUNT(*) FROM `Wagon` WHERE `idTrain_FK` = input_train_id) < 10 THEN
            SET @random_load = FLOOR(1 + RAND() * 2); -- 1: mail, 2: passengers

            INSERT INTO `Wagon` (`idTrain_FK`, `idGood_Transport_FK`)
            VALUES (input_train_id, CASE WHEN @random_load = 1 THEN 24 ELSE 25 END);
        END IF;

        SET @i = @i + 1;
    END WHILE;
END;

DELIMITER ;
