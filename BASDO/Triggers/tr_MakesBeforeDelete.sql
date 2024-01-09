DELIMITER //
DROP TRIGGER IF EXISTS tr_MakesBeforeDelete;
CREATE TRIGGER tr_MakesBeforeDelete BEFORE DELETE 
ON Makes FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`MakesAudit`
    VALUES (
      NULL,
      OLD.idGood_Makes_PKFK,
      OLD.idAsset_Makes_PKFK,
      CURRENT_TIMESTAMP,
      'Delete'
    );
END //
DELIMITER ;