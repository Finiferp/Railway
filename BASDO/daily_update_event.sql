DELIMITER //

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS daily_update_event;
CREATE EVENT IF NOT EXISTS daily_update_event
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- CALL sp_updateIndustryDaily();
    -- CALL sp_generateGoods();

END;

DELIMITER ;


