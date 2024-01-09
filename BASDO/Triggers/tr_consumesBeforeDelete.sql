DELIMITER //
DROP TRIGGER IF EXISTS tr_consumesBeforeDelete;
CREATE TRIGGER tr_consumesBeforeDelete BEFORE DELETE 
ON Consumes FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`ConsumesAudit`
        VALUES (
        NULL,
        OLD.idIndustry_Consumes_PKFK,
        OLD.idGood_Consumes_PKFK,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;