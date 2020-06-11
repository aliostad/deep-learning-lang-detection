-- Location View

SELECT dropIfExists('VIEW', 'location', 'api');
CREATE OR REPLACE VIEW api.location AS
  SELECT
    warehous_code::VARCHAR AS site,
    location_aisle::VARCHAR AS aisle,
    location_rack::VARCHAR AS rack,
    location_bin::VARCHAR AS bin,
    location_name::VARCHAR AS location,
    whsezone_name AS zone,
    location_netable AS netable,
    location_usable AS usable,
    location_restrict AS restricted,
    location_descrip AS description
    FROM location
       LEFT OUTER JOIN whsinfo ON (warehous_id=location_warehous_id)
       LEFT OUTER JOIN whsezone ON (whsezone_id=location_whsezone_id);

GRANT ALL ON TABLE api.location TO xtrole;
COMMENT ON VIEW api.location IS 'Location';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.location DO INSTEAD

  INSERT INTO location (
    location_warehous_id,
    location_name,
    location_descrip,
    location_restrict,
    location_netable,
    location_usable,
    location_whsezone_id,
    location_aisle,
    location_rack,
    location_bin
    )
  VALUES (
    getWarehousId(NEW.site, 'ACTIVE'),
    COALESCE(NEW.location,''),
    COALESCE(NEW.description, ''),
    COALESCE(NEW.restricted, false),
    COALESCE(NEW.netable, true),
    COALESCE(NEW.usable, true),
    getWhseZoneId(NEW.site, NEW.zone),
    COALESCE(NEW.aisle, ''),
    COALESCE(NEW.rack, ''),
    COALESCE(NEW.bin, '')
    );

CREATE OR REPLACE RULE "_UPDATE" AS 
    ON UPDATE TO api.location DO INSTEAD

  UPDATE location SET
    location_name=NEW.location,
    location_descrip=NEW.description,
    location_restrict=NEW.restricted,
    location_netable=NEW.netable,
    location_usable=NEW.usable,
    location_whsezone_id=getWhseZoneId(NEW.site, NEW.zone),
    location_aisle=NEW.aisle,
    location_rack=NEW.rack,
    location_bin=NEW.bin
  WHERE ( (location_warehous_id=getWarehousId(OLD.site, 'ACTIVE')) AND
          (location_name=OLD.location) );
           
CREATE OR REPLACE RULE "_DELETE" AS 
    ON DELETE TO api.location DO INSTEAD

  DELETE FROM location
  WHERE ( (location_warehous_id=getWarehousId(OLD.site, 'ACTIVE')) AND
          (location_name=OLD.location) );
