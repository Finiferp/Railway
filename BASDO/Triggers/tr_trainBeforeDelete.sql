DELIMITER //
DROP TRIGGER IF EXISTS tr_trainBeforeDelete;
CREATE TRIGGER tr_trainBeforeDelete BEFORE DELETE 
ON Train FOR EACH ROW
BEGIN
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
        'Delete'
    );
END //
DELIMITER ;