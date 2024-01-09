DELIMITER //
DROP TRIGGER IF EXISTS tr_wagonBeforeUpdate;
CREATE TRIGGER tr_wagonBeforeUpdate BEFORE UPDATE 
ON Wagon FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idWagon_PK <=> OLD.idWagon_PK AND
        NEW.idTrain_FK <=> OLD.idTrain_FK AND
        NEW.idGood_Transport_FK <=> OLD.idGood_Transport_FK
    ) THEN
        INSERT INTO `RailwayAudit`.`WagonAudit`
        VALUES (
        NULL,
        OLD.idWagon_PK,
        OLD.idTrain_FK,
        OLD.idGood_Transport_FK,
        CURRENT_TIMESTAMP,
        'Update'
        );
  END IF;
END//
DELIMITER;