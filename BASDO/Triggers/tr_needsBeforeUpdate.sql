DELIMITER //
DROP TRIGGER IF EXISTS tr_needsBeforeUpdate;
CREATE TRIGGER tr_needsBeforeUpdate BEFORE UPDATE 
ON Needs FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idAsset_Needs_PKFK <=> OLD.idAsset_Needs_PKFK AND
        NEW.idGood_Needs_PKFK <=> OLD.idGood_Needs_PKFK AND
        NEW.consumption <=> OLD.consumption
    ) THEN
        INSERT INTO `RailwayAudit`.`NeedsAudit`
        VALUES (
        NULL,
        OLD.idAsset_Needs_PKFK,
        OLD.idGood_Needs_PKFK,
        OLD.consumption,
        CURRENT_TIMESTAMP,
        'Update'
        );
    END IF;
END//
DELIMITER;