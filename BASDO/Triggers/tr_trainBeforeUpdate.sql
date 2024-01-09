DELIMITER //
DROP TRIGGER IF EXISTS tr_trainBeforeUpdate;
CREATE TRIGGER tr_trainBeforeUpdate BEFORE UPDATE 
ON Train FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idTrain_PK <=> OLD.idTrain_PK AND
        NEW.name <=> OLD.name AND
        NEW.cost <=> OLD.cost AND
        NEW.operationalCost <=> OLD.operationalCost AND
        NEW.traveledDistance <=> OLD.traveledDistance AND
        NEW.idRailway_FK <=> OLD.idRailway_FK AND
        NEW.idAsset_Starts_FK <=> OLD.idAsset_Starts_FK AND
        NEW.idAsset_Destines_FK <=> OLD.idAsset_Destines_FK AND
        NEW.willReturnWithGoods <=> OLD.willReturnWithGoods AND
        NEW.isReturning <=> OLD.isReturning
    ) THEN
        INSERT INTO `RailwayAudit`.`TrainAudit`
        VALUES (
        NULL,
        OLD.idTrain_PK,
        OLD.name,
        OLD.cost,
        OLD.operationalCost,
        OLD.traveledDistance,
        OLD.idRailway_FK,
        OLD.idAsset_Starts_FK,
        OLD.idAsset_Destines_FK,
        OLD.willReturnWithGoods,
        OLD.isReturning,
        CURRENT_TIMESTAMP,
        'Update'
        );
    END IF;
END//
DELIMITER;