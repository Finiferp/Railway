DELIMITER //
DROP TRIGGER IF EXISTS tr_railwayBeforeUpdate;
CREATE TRIGGER tr_railwayBeforeUpdate BEFORE UPDATE 
ON Railway FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idRailway_PK <=> OLD.idRailway_PK AND
        NEW.distance <=> OLD.distance
    ) THEN
    
        INSERT INTO `RailwayAudit`.`RailwayAudit`
        VALUES (
        NULL,
        OLD.idRailway_PK,
        OLD.distance,
        CURRENT_TIMESTAMP,
        'Update'
        );
    END IF;
END//
DELIMITER;