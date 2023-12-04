DELIMITER //
DROP PROCEDURE IF EXISTS sp_updateIndustryDaily;
CREATE PROCEDURE sp_updateIndustryDaily()
BEGIN
 DECLARE done INT DEFAULT 0;
    DECLARE industry_id INT;
    DECLARE industry_type ENUM('BREWERY','BUTCHER','BAKERY','SAWMILL','CHEESEMAKER','CARPENTER','TAILOR','SMELTER','SMITHY','JEWELER');
    DECLARE good_id INT;
    DECLARE consume_quantity INT;
    DECLARE produce_quantity INT;
    DECLARE stockpile_quantity INT;

    DECLARE industry_cursor CURSOR FOR SELECT idIndustry_PK, type, idGood_Produce_FK FROM Industry;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN industry_cursor;
    industry_loop: LOOP
        FETCH industry_cursor INTO industry_id, industry_type, good_id;

        IF done = 1 THEN
            LEAVE industry_loop;
        END IF;

        IF industry_type IN ('CARPENTER','TAILOR','JEWLER') THEN
            SET consume_quantity = 1;
            SET produce_quantity = 2;
        ELSE
            SET consume_quantity = 2;
            SET produce_quantity = 2;
        END IF;

  
        SELECT quantity INTO stockpile_quantity
        FROM Stockpiles
        WHERE idAsset_Stockpiles_PKFK = industry_id AND idGoodt_Stockpiles_PKFK = good_id;


        IF stockpile_quantity >= consume_quantity THEN
            UPDATE Stockpiles SET quantity = stockpile_quantity - consume_quantity 
            WHERE idAsset_Stockpiles_PKFK = industry_id AND idGoodt_Stockpiles_PKFK = good_id;

            UPDATE Industry
            SET warehouseCapacity = GREATEST(0, LEAST(warehouseCapacity + produce_quantity, 20))
            WHERE idIndustry_PK = industry_id;

        END IF;
    END LOOP;
    
    CLOSE industry_cursor;
END;
DELIMITER;