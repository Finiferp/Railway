DELIMITER //
DROP PROCEDURE IF EXISTS sp_updateAssetNeeds;
CREATE PROCEDURE sp_updateAssetNeeds(IN assetId INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE goodId INT;
    DECLARE consumption FLOAT;
    DECLARE availableStockpile INT;
    DECLARE needs_count INT DEFAULT 0; 
    DECLARE needs_satisfied INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
        SELECT idGood_Needs_PKFK, consumption FROM Needs WHERE idAsset_Needs_PKFK = assetId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO goodId, consumption;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SELECT quantity INTO availableStockpile 
        FROM Stockpiles 
        WHERE idAsset_Stockpiles_PKFK = assetId AND idGoodt_Stockpiles_PKFK = goodId;
        
        SET needs_count = needs_count + 1;
        
        IF availableStockpile >= consumption THEN
            SET needs_satisfied = needs_satisfied + 1;
            UPDATE Stockpiles
            SET quantity = quantity - consumption
            WHERE idAsset_Stockpiles_PKFK = assetId AND idGoodt_Stockpiles_PKFK = goodId;
        END IF;
    END LOOP;
    CLOSE cur;
    
    SET @percentage = (needs_satisfied / needs_count) * 100;
    
    IF @percentage >= 75 THEN
        UPDATE Asset
        SET population = population * (1 + 0.1)
        WHERE idAsset_PK = assetId;
    ELSEIF @percentage <= 50 THEN
        UPDATE Asset
        SET population = GREATEST(population * (1 - 0.1), 500)
        WHERE idAsset_PK = assetId;
    END IF;
END //
DELIMITER ;