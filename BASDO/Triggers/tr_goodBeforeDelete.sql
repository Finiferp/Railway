DELIMITER //
DROP TRIGGER IF EXISTS tr_goodBeforeDelete;
CREATE TRIGGER tr_goodBeforeDelete BEFORE DELETE 
ON Good FOR EACH ROW
BEGIN
     INSERT INTO `RailwayAudit`.`GoodAudit`
        VALUES (
        NULL,
        OLD.idGood_PK,
        OLD.name,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;