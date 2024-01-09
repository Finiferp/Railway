DELIMITER //
DROP TRIGGER IF EXISTS tr_stockpilesBeforeDelete;
CREATE TRIGGER tr_stockpilesBeforeDelete BEFORE DELETE 
ON Stockpiles FOR EACH ROW
BEGIN
   INSERT INTO `RailwayAudit`.`StockpilesAudit`
        VALUES (
        NULL,
        OLD.idAsset_Stockpiles_PKFK,
        OLD.idGoodt_Stockpiles_PKFK,
        OLD.quantity,
        CURRENT_TIMESTAMP,
        'Delete'
    );
END //
DELIMITER ;