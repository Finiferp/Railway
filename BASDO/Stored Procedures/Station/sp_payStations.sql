DELIMITER //
DROP PROCEDURE IF EXISTS sp_payStations;
CREATE PROCEDURE sp_payStations()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE playerId INT;
    DECLARE fundsToDecrease INT;

    DECLARE player_cursor CURSOR FOR SELECT idPlayer_PK FROM Player;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN player_cursor;
    player_loop: LOOP
        FETCH player_cursor INTO playerId;

        IF done = 1 THEN
            LEAVE player_loop;
        END IF;

        SELECT COUNT(*) INTO fundsToDecrease
        FROM Station s
        JOIN Asset a ON s.idAsset_FK = a.idAsset_PK
        WHERE a.idOwner_FK = playerId;

        IF fundsToDecrease > 0 THEN
            CALL sp_deleteFunds(1000*fundsToDecrease, playerId);
        END IF;
    END LOOP;

    CLOSE player_cursor;
END //
DELIMITER ;