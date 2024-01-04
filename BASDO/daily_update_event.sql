DELIMITER //
SET GLOBAL event_scheduler = ON;
DROP EVENT IF EXISTS daily_update_event;
CREATE EVENT IF NOT EXISTS daily_update_event
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    CALL sp_generateGoods();
    CALL sp_updateIndustryDaily();
    CALL sp_moveTrain();
    CALL sp_updateStockpile();
END;


DROP EVENT IF EXISTS weekly_update_event;
CREATE EVENT IF NOT EXISTS weekly_update_event
ON SCHEDULE EVERY 7 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    CALL sp_payStations();
END;
DELIMITER ;


