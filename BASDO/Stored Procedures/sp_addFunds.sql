DELIMITER //
DROP PROCEDURE IF EXISTS sp_addFunds;
CREATE PROCEDURE sp_addFunds(IN amount INT, playerID INT)
BEGIN
    UPDATE Player SET funds = funds + amount WHERE idPlayer_PK = playerID;
END;
DELIMITER ;