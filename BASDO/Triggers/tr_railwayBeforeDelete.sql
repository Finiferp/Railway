DELIMITER //
DROP TRIGGER IF EXISTS tr_railwayBeforeDelete;
CREATE TRIGGER tr_railwayBeforeDelete BEFORE DELETE 
ON Railway FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`RailwayAudit`
        VALUES (
        NULL,
        OLD.idRailway_PK,
        OLD.distance,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;