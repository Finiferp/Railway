DELIMITER //
DROP TRIGGER IF EXISTS tr_assetBeforeUpdate;
CREATE TRIGGER tr_assetBeforeUpdate BEFORE UPDATE ON Asset FOR EACH ROW
BEGIN
    -- Check if population is between two levels
    IF NEW.population <> OLD.population THEN
        IF 500 <= NEW.population AND NEW.population <= 1000 THEN
            SET NEW.level = 1;
        ELSEIF 1000 < NEW.population AND NEW.population <= 2000 THEN
            SET NEW.level = 2;
        ELSEIF 2000 < NEW.population AND NEW.population <= 5000 THEN
            SET NEW.level = 3;
        ELSEIF 5000 < NEW.population AND NEW.population <= 10000 THEN
            SET NEW.level = 4;
        ELSEIF 10000 < NEW.population AND NEW.population <= 20000 THEN
            SET NEW.level = 5;
        END IF;
    END IF;
END;
DELIMITER ;
