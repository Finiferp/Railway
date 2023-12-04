DELIMITER //
DROP TRIGGER IF EXISTS tr_assetAfterUpdate;
CREATE TRIGGER tr_assetAfterUpdate AFTER UPDATE ON Asset FOR EACH ROW
BEGIN
    IF NEW.level < OLD.level THEN
      CALL sp_changeNeeds(NEW.idAsset_PK, NEW.level, 0);
    ELSEIF NEW.level > OLD.level THEN
      CALL sp_changeNeeds(NEW.idAsset_PK, NEW.level, 1);
    END IF;
END;
DELIMITER ;