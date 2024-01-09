DELIMITER //

DROP TRIGGER IF EXISTS tr_consumesBeforeUpdate;

CREATE TRIGGER tr_consumesBeforeUpdate BEFORE UPDATE 
ON Consumes FOR EACH ROW 
BEGIN 
	IF NOT (
        NEW.idIndustry_Consumes_PKFK <=> OLD.idIndustry_Consumes_PKFK AND
        NEW.idGood_Consumes_PKFK <=> OLD.idGood_Consumes_PKFK
    ) THEN
        INSERT INTO `RailwayAudit`.`ConsumesAudit`
        VALUES (
        NULL,
        OLD.idIndustry_Consumes_PKFK,
        OLD.idGood_Consumes_PKFK,
        CURRENT_TIMESTAMP,
        'Update'
        );
  END IF;
END//

DELIMITER;