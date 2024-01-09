DELIMITER //
DROP TRIGGER IF EXISTS tr_industryBeforeDelete;
CREATE TRIGGER tr_industryBeforeDelete BEFORE DELETE 
ON Industry FOR EACH ROW
BEGIN
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
        'Delete'
    );
END //
DELIMITER ;