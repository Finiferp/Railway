DELIMITER //
DROP TRIGGER IF EXISTS tr_worldBeforeUpdate;
CREATE TRIGGER tr_worldBeforeUpdate BEFORE UPDATE 
ON World FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idWorld_PK <=> OLD.idWorld_PK AND
        NEW.creationDate <=> OLD.creationDate
    ) THEN
        INSERT INTO `RailwayAudit`.`WorldAudit`
        VALUES (
        NULL,
        OLD.idWorld_PK,
        OLD.creationDate,
        CURRENT_TIMESTAMP,
        'Update'
        );
    END IF;
END//
DELIMITER;