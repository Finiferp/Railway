DELIMITER //
DROP TRIGGER IF EXISTS tr_MakesBeforeUpdate;

CREATE TRIGGER tr_MakesBeforeUpdate BEFORE UPDATE 
ON Makes FOR EACH ROW
BEGIN 
   IF NOT (
    NEW.idGood_Makes_PKFK <=> OLD.idGood_Makes_PKFK AND
    NEW.idAsset_Makes_PKFK <=> OLD.idAsset_Makes_PKFK
  ) THEN
    INSERT INTO `RailwayAudit`.`MakesAudit`
    VALUES (
      NULL,
      OLD.idGood_Makes_PKFK,
      OLD.idAsset_Makes_PKFK,
      CURRENT_TIMESTAMP,
      'Update'
    );
  END IF;
END//
DELIMITER;