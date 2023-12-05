DELIMITER //
DROP PROCEDURE IF EXISTS sp_deleteTrain;
CREATE PROCEDURE sp_deleteTrain(IN json_data JSON)
BEGIN
    DECLARE user_id INT;
    DECLARE train_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE exit_exception BOOLEAN DEFAULT FALSE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET exit_exception := TRUE;
    END;

    SET user_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.userId'));
    SET train_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.trainId'));

    START TRANSACTION;

    DELETE FROM Wagon WHERE idTrain_FK = train_id; -- NOT needed due to ON UPDATE/DELETE CASCADE, still just to be sure 
    DELETE FROM Train WHERE idTrain_PK = train_id;

    IF exit_exception THEN
        ROLLBACK;
        SET response_code = 500;
        SET response_message = 'Internal Server Error';
    ELSE
        COMMIT;
        CALL sp_addFunds(50000, userId);
        SET response_code = 200;
        SET response_message = 'Train and wagons deleted successfully';
    END IF;

    SELECT JSON_OBJECT(
        'status_code', response_code,
        'message', response_message
    ) AS 'result';
END //

DELIMITER ;
