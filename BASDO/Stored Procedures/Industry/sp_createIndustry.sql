DELIMITER //
DROP PROCEDURE IF EXISTS sp_createIndustry;
CREATE PROCEDURE sp_createIndustry(IN json_data JSON)
BEGIN
    DECLARE input_name VARCHAR(450);
    DECLARE input_id_asset INT;
    DECLARE input_type ENUM('BREWERY','BUTCHER','BAKERY','SAWMILL','CHEESEMAKER','CARPENTER','TAILOR','SMELTER','SMITHY','JEWELER');
    DECLARE new_industry_id INT;
    DECLARE industry_price INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE num_existing_industries INT;
    DECLARE asset_level INT;
    DECLARE user_id INT;

    -- Extracting data from JSON input
    SET input_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.name'));
    SET input_id_asset = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.idAsset'));
    SET input_type = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.type'));

    IF (SELECT type FROM Asset WHERE idAsset_PK = input_id_asset) = 'TOWN' THEN
        SET num_existing_industries = (SELECT COUNT(*) FROM Industry WHERE idAsset_FK = input_id_asset);
        SET asset_level = (SELECT level FROM Asset WHERE idAsset_PK = input_id_asset);
        -- Check the conditions for creating a new industry
        IF asset_level = 1 AND num_existing_industries = 0 THEN
            -- Level 1 asset can't have any industry
            SET response_code = 400;
            SET response_message = 'Level 1 asset cannot have any industry';
        ELSEIF asset_level = 2 AND num_existing_industries >= 1 THEN
             SET response_code = 400;
            SET response_message = 'Level 2 asset can have at most 1 industry';
        ELSEIF asset_level = 3 AND num_existing_industries >= 1 THEN
            -- Level 3 asset can have a maximum of 1 industry
            SET response_code = 400;
            SET response_message = 'Level 3 asset can have at most 1 industry';
        ELSEIF asset_level = 4 AND num_existing_industries >= 2 THEN
            -- Level 4 asset can have a maximum of 2 industries
            SET response_code = 400;
            SET response_message = 'Level 4 asset can have at most 2 industries';
        ELSEIF asset_level = 5 AND num_existing_industries >= 3 THEN
            -- Level 5 asset can have a maximum of 3 industries
            SET response_code = 400;
            SET response_message = 'Level 5 asset can have at most 3 industries';
        ELSE
        -- Insert data into Consumes table based on industry type
        CASE input_type
            WHEN 'BREWERY' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 2);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 1);
            WHEN 'BUTCHER' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 12);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 21);
            WHEN 'BAKERY' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 13);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 3);
            WHEN 'SAWMILL' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 6);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 4);
            WHEN 'CHEESEMAKER' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 15);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 5);
            WHEN 'CARPENTER' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 16);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 6);
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 23);
            WHEN 'TAILOR' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 17);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 4);
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 23);
            WHEN 'SMELTER' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 18);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 8);
            WHEN 'SMITHY' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 19);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 18);
            WHEN 'JEWLER' THEN
                INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 20);
                SET new_industry_id = LAST_INSERT_ID();
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 19);
                INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 11);
            END CASE;
            SET response_code = 201;
            SET response_message = 'Industry created successfully';
            SELECT cost INTO industry_price FROM Industry WHERE idIndustry_PK = new_industry_id;
            SELECT idOwner_FK into user_id FROM Industry JOIN Asset WHERE idAsset_FK = idAsset_PK AND idIndustry_PK = new_industry_id;
            CALL sp_deleteFunds(industry_price, user_id);
        END IF;
    ELSE
        SET response_code = 400;
        SET response_message = 'Failed to create industry';
    END IF;

    -- Return the JSON response
    SELECT 
        CASE
            WHEN response_code = 201 THEN
                JSON_OBJECT('status_code', response_code, 'message', response_message, 'industry', 
                    JSON_OBJECT('id', new_industry_id, 'name', input_name, 'type', input_type, 'idAsset', input_id_asset))
            ELSE
                JSON_OBJECT('status_code', response_code, 'message', response_message)
        END AS 'result';

END //

DELIMITER ;
