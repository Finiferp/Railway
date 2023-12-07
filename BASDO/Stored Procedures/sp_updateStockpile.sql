DELIMITER //
DROP PROCEDURE IF EXISTS sp_updateStockpile;
CREATE PROCEDURE sp_updateStockpile()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE assetId INT;
    DECLARE assetName VARCHAR(450);

    DECLARE cur CURSOR FOR 
        SELECT idAsset_PK FROM Asset WHERE type = 'TOWN';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO assetId;
        IF done THEN
            LEAVE read_loop;
        END IF;
        CALL sp_updateAssetNeeds(assetId)
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;