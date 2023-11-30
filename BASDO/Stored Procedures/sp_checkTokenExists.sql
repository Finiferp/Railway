DELIMITER //
DROP PROCEDURE IF EXISTS sp_checkTokenExists;
CREATE PROCEDURE sp_checkTokenExists(IN p_token VARCHAR(255))
BEGIN
    DECLARE token_exists INT;

    SELECT COUNT(*) INTO token_exists
    FROM Token
    WHERE type = p_token;
    SELECT token_exists AS result;
END //

DELIMITER ;
