DELIMITER //
DROP TRIGGER IF EXISTS tr_assetBeforeUpdate;
CREATE TRIGGER tr_assetBeforeUpdate BEFORE UPDATE 
ON Asset FOR EACH ROW
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


    IF NOT (
        NEW.name <=> OLD.name AND
        NEW.type <=> OLD.type AND
        NEW.population <=> OLD.population AND
        NEW.level <=> OLD.level AND
        NEW.stockpileMax <=> OLD.stockpileMax AND
        NEW.idWorld_FK <=> OLD.idWorld_FK AND
        NEW.position <=> OLD.position AND
        NEW.idOwner_FK <=> OLD.idOwner_FK AND
        NEW.cost <=> OLD.cost
        ) THEN
        INSERT INTO `RailwayAudit`.`AssetAudit`
        VALUES (
            NULL,
            OLD.idAsset_PK,
            OLD.name,
            CAST(OLD.type AS CHAR),
            OLD.population,
            OLD.level,
            OLD.stockpileMax,
            OLD.idWorld_FK,
            OLD.position,
            OLD.idOwner_FK,
            OLD.cost,
            CURRENT_TIMESTAMP,
            "Update"
        );
    END IF;
END //
DELIMITER ;
