DELIMITER //
DROP TRIGGER IF EXISTS tr_stockpilesBeforeUpdate;
CREATE TRIGGER tr_stockpilesBeforeUpdate BEFORE UPDATE 
ON Stockpiles FOR EACH ROW
BEGIN 
    IF NOT (
        NEW.idAsset_Stockpiles_PKFK <=> OLD.idAsset_Stockpiles_PKFK AND
        NEW.idGoodt_Stockpiles_PKFK <=> OLD.idGoodt_Stockpiles_PKFK AND
        NEW.quantity <=> OLD.quantity
    ) THEN
        INSERT INTO `RailwayAudit`.`StockpilesAudit`
        VALUES (
        NULL,
        OLD.idAsset_Stockpiles_PKFK,
        OLD.idGoodt_Stockpiles_PKFK,
        OLD.quantity,
        CURRENT_TIMESTAMP,
        'Update'
        );
    END IF;
END//
DELIMITER;