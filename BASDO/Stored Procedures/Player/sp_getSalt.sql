DELIMITER  //
DROP PROCEDURE IF EXISTS sp_getSalt;
CREATE PROCEDURE sp_getSalt(IN p_username VARCHAR(80))
BEGIN
    DECLARE v_salt VARCHAR(450);
    SELECT salt INTO v_salt FROM Player WHERE username = p_username;
	SELECT v_salt AS salt;
END //
DELIMITER ;