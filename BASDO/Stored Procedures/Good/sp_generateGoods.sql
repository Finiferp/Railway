DELIMITER //
DROP PROCEDURE IF EXISTS sp_generateGoods;
CREATE PROCEDURE sp_generateGoods()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE asset_id INT;
    DECLARE asset_level INT;
    DECLARE mail_quantity INT;
    DECLARE passengers_quantity INT;
    DECLARE asset_cursor CURSOR FOR SELECT idAsset_PK, level FROM Asset WHERE type = 'TOWN';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN asset_cursor;

    asset_loop: LOOP
        FETCH asset_cursor INTO asset_id, asset_level;

        IF done = 1 THEN
            LEAVE asset_loop;
        END IF;

        SET mail_quantity = 0;
        SET passengers_quantity = 0;
        CASE
            WHEN asset_level = 1 THEN
                SET mail_quantity = 5;
                SET passengers_quantity = 10;
            WHEN asset_level = 2 THEN
                SET mail_quantity = 10;
                SET passengers_quantity = 20;
            WHEN asset_level = 3 THEN
                SET mail_quantity = 50;
                SET passengers_quantity = 40;
            WHEN asset_level = 4 THEN
                SET mail_quantity = 200;
                SET passengers_quantity = 100;
            WHEN asset_level = 5 THEN
                SET mail_quantity = 250;
                SET passengers_quantity = 150;
        END CASE;

        INSERT INTO Stockpiles (idAsset_Stockpiles_PKFK, idGoodt_Stockpiles_PKFK, quantity)
        VALUES
            (asset_id, 24, mail_quantity),
            (asset_id, 25, passengers_quantity)
        ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity);

    END LOOP;

    CLOSE asset_cursor;
END ;
DELIMITER ;