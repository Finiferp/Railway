DELIMITER //
DROP TRIGGER IF EXISTS tr_needsBeforeDelete;
CREATE TRIGGER tr_needsBeforeDelete BEFORE DELETE 
ON Needs FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`NeedsAudit`
        VALUES (
        NULL,
        OLD.idAsset_Needs_PKFK,
        OLD.idGood_Needs_PKFK,
        OLD.consumption,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;