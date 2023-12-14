DELIMITER //
DROP PROCEDURE IF EXISTS sp_createBusiness;
CREATE PROCEDURE sp_createBusiness(IN business VARCHAR(450), assetId INT)
BEGIN
    IF business = 'RANCH' THEN
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (21,assetId);
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (5,assetId);
    ELSEIF business = 'FIELD' THEN
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (3,assetId);
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (1,assetId);
    ELSEIF business = 'FARM' THEN
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (20,assetId);
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (7,assetId);
    ELSEIF business = 'LUMBERYARD' THEN
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (4,assetId);
    ELSEIF business = 'PLANTATION' THEN
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (22,assetId);
    ELSEIF business = 'MINE' THEN
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (8,assetId);
        INSERT INTO Makes(idGood_Makes_PKFK, idAsset_Makes_PKFK) VALUES (11,assetId);
    END IF;
END;
DELIMITER;