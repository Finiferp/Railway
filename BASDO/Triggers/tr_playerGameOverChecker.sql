DELIMITER //
DROP TRIGGER IF EXISTS tr_playerGameOverChecker;
CREATE TRIGGER tr_playerGameOverChecker BEFORE UPDATE ON Player FOR EACH ROW
BEGIN
    IF NEW.funds < -50000 THEN
        SET NEW.idWorld_FK = -1;
    END IF;
END;
DELIMITER ;