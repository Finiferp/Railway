
DELIMITER //
DROP TRIGGER IF EXISTS tr_stationBeforeDelete;
CREATE TRIGGER tr_stationBeforeDelete BEFORE DELETE 
ON Station FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`StationAudit`
        VALUES (
        NULL,
        OLD.idStation_PK,
        OLD.name,
        OLD.cost,
        OLD.operationCost,
        OLD.idAsset_FK,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;