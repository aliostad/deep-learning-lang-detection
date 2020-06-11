-- *************************************************************************************************
-- * update-district.sql                                                                           *
-- *                                                                                               *
-- * Update a district name                                                                        *
-- * :newName - new name for the district;                                                         *
-- * :oldName - name of the district to update;                                                    *
-- *                                                                                               *
-- * psql -v oldName="'OLD_NAME'" -v newName="'NEW_NAME'" [login options...] < update-district.sql *
-- *************************************************************************************************

UPDATE withdrawal        SET district = :newName WHERE district = :oldName;
UPDATE market_price      SET district = :newName WHERE district = :oldName;
UPDATE fertilizer        SET district = :newName WHERE district = :oldName;
UPDATE district_crop_map SET district = :newName WHERE district = :oldName;
UPDATE district_select   SET district = :newName WHERE district = :oldName;
UPDATE district_boundary SET district = :newName WHERE district = :oldName;
UPDATE agromet           SET district = :newName WHERE district = :oldName;
UPDATE cropdata          SET district = :newName WHERE district = :oldName;
UPDATE district_view     SET "DISTRICT" = :newName WHERE "DISTRICT" = :oldName;
UPDATE district_crop     SET district = :newName WHERE district = :oldName;
