DELIMITER //
DROP TRIGGER IF EXISTS tr_playerBeforeUpdate;
CREATE TRIGGER tr_playerBeforeUpdate BEFORE UPDATE 
ON Player FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idPlayer_PK <=> OLD.idPlayer_PK AND
        NEW.username <=> OLD.username AND
        NEW.password <=> OLD.password AND
        NEW.salt <=> OLD.salt AND
        NEW.idWorld_FK <=> OLD.idWorld_FK AND
        NEW.funds <=> OLD.funds
    ) THEN
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
        'Update'
        );
    END IF;
END//
DELIMITER;