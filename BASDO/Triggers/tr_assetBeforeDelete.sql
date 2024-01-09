DELIMITER //
DROP TRIGGER IF EXISTS tr_assetBeforeDelete;
CREATE TRIGGER tr_assetBeforeDelete BEFORE DELETE 
ON Asset FOR EACH ROW
BEGIN
    INSERT INTO `RailwayAudit`.`AssetAudit`
        VALUES (
            NULL,
            OLD.idAsset_PK,
            OLD.name,
            CAST(OLD.type AS CHAR),
            OLD.population,
            OLD.level,
            OLD.stockpileMax,
            OLD.idWorld_FK,
            OLD.position,
            OLD.idOwner_FK,
            OLD.cost,
            CURRENT_TIMESTAMP,
            "Delete"
        );
END //
DELIMITER ;