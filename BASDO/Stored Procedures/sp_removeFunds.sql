DELIMITER //
DROP PROCEDURE IF EXISTS sp_deleteFunds;
CREATE PROCEDURE sp_deleteFunds(IN amount INT, playerID INT)
BEGIN
    UPDATE Player SET funds = funds - amount WHERE idPlayer_PK = playerID;
END;
DELIMITER ;