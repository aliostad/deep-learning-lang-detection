-- *************************************************************************************************
-- * update-province.sql                                                                           *
-- *                                                                                               *
-- * Update a province name                                                                        *
-- * :newName - new name for the province;                                                         *
-- * :oldName - name of the province to update;                                                    *
-- *                                                                                               *
-- * psql -v oldName="'OLD_NAME'" -v newName="'NEW_NAME'" [login options...] < update-province.sql *
-- *************************************************************************************************

UPDATE withdrawal        SET province = :newName WHERE province = :oldName;
UPDATE market_price      SET province = :newName WHERE province = :oldName;
UPDATE fertilizer        SET province = :newName WHERE province = :oldName;
UPDATE district_crop_map SET province = :newName WHERE province = :oldName;
UPDATE district_select   SET province = :newName WHERE province = :oldName;
UPDATE district_boundary SET province = :newName WHERE province = :oldName;
UPDATE agromet           SET province = :newName WHERE province = :oldName;
UPDATE cropdata          SET province = :newName WHERE province = :oldName;
UPDATE district_view     SET "PROVINCE" = :newName WHERE "PROVINCE" = :oldName;
UPDATE district_crop     SET province = :newName WHERE province = :oldName;
UPDATE province_crop_map SET province = :newName WHERE province = :oldName;
UPDATE province_crop     SET province = :newName WHERE province = :oldName;
UPDATE province_select   SET province = :newName WHERE province = :oldName;
UPDATE province_boundary SET province = :newName WHERE province = :oldName;
UPDATE province_view     SET province = :newName WHERE province = :oldName;
