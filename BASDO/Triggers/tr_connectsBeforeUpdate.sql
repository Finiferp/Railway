DELIMITER //

DROP TRIGGER IF EXISTS tr_connectsBeforeUpdate;

CREATE TRIGGER tr_connectsBeforeUpdate BEFORE UPDATE 
ON Connects FOR EACH ROW 
BEGIN 
	IF NOT (
	    NEW.idStation_Connects_FK <=> OLD.idStation_Connects_FK
	    AND NEW.idRailway_Connects_FK <=> OLD.idRailway_Connects_FK
	) THEN 
	INSERT INTO
	    `RailwayAudit`.`ConnectsAudit`
	VALUES (
	        NULL,
	        OLD.idStation_Connects_FK,
	        OLD.idRailway_Connects_FK,
	        CURRENT_TIMESTAMP,
	        'Update'
	    );
	END IF;
END//

DELIMITER;