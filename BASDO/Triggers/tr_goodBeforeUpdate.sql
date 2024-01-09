DELIMITER //
DROP TRIGGER IF EXISTS tr_goodBeforeUpdate;

CREATE TRIGGER tr_goodBeforeUpdate BEFORE UPDATE 
ON Good FOR EACH ROW 
BEGIN 
    IF NOT (
        NEW.idGood_PK <=> OLD.idGood_PK AND
        NEW.name <=> OLD.name
    ) THEN
        INSERT INTO `RailwayAudit`.`GoodAudit`
        VALUES (
        NULL,
        OLD.idGood_PK,
        OLD.name,
        CURRENT_TIMESTAMP,
        'Update'
        );
    END IF;
END//
DELIMITER;