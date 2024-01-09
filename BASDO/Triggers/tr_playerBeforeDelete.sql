DELIMITER //
DROP TRIGGER IF EXISTS tr_playerBeforeDelete;
CREATE TRIGGER tr_playerBeforeDelete BEFORE DELETE 
ON Player FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`PlayeAudit`
        VALUES (
        NULL,
        OLD.idPlayer_PK,
        OLD.username,
        OLD.password,
        OLD.salt,
        OLD.idWorld_FK,
        OLD.funds,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;