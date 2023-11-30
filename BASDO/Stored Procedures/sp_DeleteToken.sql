DELIMITER //
DROP PROCEDURE IF EXISTS sp_deleteToken;
CREATE PROCEDURE sp_deleteToken(IN token_value VARCHAR(450))
BEGIN
   DELETE FROM Token WHERE type = token_value LIMIT 1;

END //
DELIMITER ;
