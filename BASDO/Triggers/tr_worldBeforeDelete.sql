DELIMITER //
DROP TRIGGER IF EXISTS tr_worldBeforeDelete;
CREATE TRIGGER tr_worldBeforeDelete BEFORE DELETE 
ON World FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`WorldAudit`
        VALUES (
        NULL,
        OLD.idWorld_PK,
        OLD.creationDate,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;