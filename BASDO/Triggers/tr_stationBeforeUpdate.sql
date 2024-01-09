DELIMITER //
DROP TRIGGER IF EXISTS tr_stationBeforeUpdate;
CREATE TRIGGER tr_stationBeforeUpdate BEFORE UPDATE 
ON Station FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idStation_PK <=> OLD.idStation_PK AND
        NEW.name <=> OLD.name AND
        NEW.cost <=> OLD.cost AND
        NEW.operationCost <=> OLD.operationCost AND
        NEW.idAsset_FK <=> OLD.idAsset_FK
    ) THEN
        INSERT INTO `RailwayAudit`.`StationAudit`
        VALUES (
        NULL,
        OLD.idStation_PK,
        OLD.name,
        OLD.cost,
        OLD.operationCost,
        OLD.idAsset_FK,
        CURRENT_TIMESTAMP,
        'Update'
        );
  END IF;
END//
DELIMITER;