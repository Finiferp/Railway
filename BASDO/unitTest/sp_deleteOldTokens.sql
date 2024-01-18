DELIMITER //

CREATE PROCEDURE sp_deleteOldTokens()
BEGIN
    DECLARE cutoffTime DATETIME;
    SET cutoffTime = NOW() - INTERVAL 12 HOUR - INTERVAL 5 MINUTE;
    DELETE FROM Token WHERE creationTime < cutoffTime;
END //
DELIMITER ;
