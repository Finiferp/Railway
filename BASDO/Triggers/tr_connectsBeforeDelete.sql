DELIMITER //
DROP TRIGGER IF EXISTS tr_connectsBeforeDelete;
CREATE TRIGGER tr_connectsBeforeDelete BEFORE DELETE 
ON Connects FOR EACH ROW
BEGIN
   INSERT INTO `RailwayAudit`.`ConnectsAudit`
	VALUES (
	        NULL,
	        OLD.idStation_Connects_FK,
	        OLD.idRailway_Connects_FK,
	        CURRENT_TIMESTAMP,
	        'Delete'
	    );
END //
DELIMITER ;