DELIMITER //
DROP TRIGGER IF EXISTS tr_wagonBeforeDelete;
CREATE TRIGGER tr_wagonBeforeDelete BEFORE DELETE 
ON Wagon FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`WagonAudit`
        VALUES (
        NULL,
        OLD.idWagon_PK,
        OLD.idTrain_FK,
        OLD.idGood_Transport_FK,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;