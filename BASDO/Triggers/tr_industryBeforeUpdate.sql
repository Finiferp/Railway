DELIMITER //
DROP TRIGGER IF EXISTS tr_industryBeforeUpdate;

CREATE TRIGGER tr_industryBeforeUpdate BEFORE UPDATE 
ON Industry FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idIndustry_PK <=> OLD.idIndustry_PK AND
        NEW.name <=> OLD.name AND
        NEW.warehouseCapacity <=> OLD.warehouseCapacity AND
        NEW.idAsset_FK <=> OLD.idAsset_FK AND
        NEW.type <=> OLD.type AND
        NEW.idGood_Produce_FK <=> OLD.idGood_Produce_FK AND
        NEW.cost <=> OLD.cost AND
        NEW.upkeepcost <=> OLD.upkeepcost
    ) THEN
        INSERT INTO `RailwayAudit`.`IndustryAudit`
        VALUES (
        NULL,
        OLD.idIndustry_PK,
        OLD.name,
        OLD.warehouseCapacity,
        OLD.idAsset_FK,
        OLD.type,
        OLD.idGood_Produce_FK,
        OLD.cost,
        OLD.upkeepcost,
        CURRENT_TIMESTAMP,
        'Update'
        );
    END IF;
END//
DELIMITER;