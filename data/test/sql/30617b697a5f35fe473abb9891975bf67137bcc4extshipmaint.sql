  --External Shipping Maintenance View

  SELECT dropifexists('view', 'extshipmaint','api');

  CREATE OR REPLACE VIEW api.extshipmaint AS

  SELECT
    shipdata_cohead_number::VARCHAR AS so_number,
    shipdata_shiphead_number::VARCHAR AS shipment_number,
    shipdata_shipper::VARCHAR AS shipper,
    shipdata_cosmisc_packnum_tracknum::VARCHAR AS package_tracking_number,
    shipdata_void_ind AS void,
    shipdata_billing_option AS billing_option,
    shipdata_weight AS weight,
    shipdata_base_freight AS base_freight,
    base.curr_abbr AS base_freight_currency,
    shipdata_total_freight AS total_freight,
    total.curr_abbr AS total_freight_currency,
    shipdata_package_type AS package_type,
    shipdata_cosmisc_tracknum AS tracking_number,
    shipdata_lastupdated AS last_updated
  FROM shipdata, curr_symbol base, curr_symbol total
  WHERE ((shipdata_base_freight_curr_id=base.curr_id)
  AND (shipdata_total_freight_curr_id=total.curr_id))
  ORDER BY shipdata_cohead_number,shipdata_shiphead_number;

GRANT ALL ON TABLE api.extshipmaint TO xtrole;
COMMENT ON VIEW api.extshipmaint IS 'External Shipping Maintenance';

  --Rules

  CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.extshipmaint DO INSTEAD

  INSERT INTO shipdata (
    shipdata_cohead_number,
    shipdata_shiphead_number,
    shipdata_void_ind,
    shipdata_shipper,
    shipdata_billing_option,
    shipdata_weight,
    shipdata_base_freight,
    shipdata_base_freight_curr_id,
    shipdata_total_freight,
    shipdata_total_freight_curr_id,
    shipdata_package_type,
    shipdata_cosmisc_tracknum,
    shipdata_cosmisc_packnum_tracknum,
    shipdata_lastupdated)
  VALUES (
    NEW.so_number,
    NEW.shipment_number,
    NEW.void,
    NEW.shipper,
    NEW.billing_option,
    NEW.weight,
    NEW.base_freight,
    getCurrId(NEW.base_freight_currency),
    NEW.total_freight,
    getCurrId(NEW.total_freight_currency),
    NEW.package_type,
    NEW.tracking_number,
    NEW.package_tracking_number,
    NEW.last_updated);
 
  CREATE OR REPLACE RULE "_UPDATE" AS
  ON UPDATE TO api.extshipmaint DO INSTEAD

  UPDATE shipdata SET
    shipdata_cohead_number=NEW.so_number,
    shipdata_shiphead_number=NEW.shipment_number,
    shipdata_void_ind=NEW.void,
    shipdata_shipper=NEW.shipper,
    shipdata_billing_option=NEW.billing_option,
    shipdata_weight=NEW.weight,
    shipdata_base_freight=NEW.base_freight,
    shipdata_base_freight_curr_id=getCurrId(NEW.base_freight_currency),
    shipdata_total_freight=NEW.total_freight,
    shipdata_total_freight_curr_id=getCurrId(NEW.total_freight_currency),
    shipdata_package_type=NEW.package_type,
    shipdata_cosmisc_tracknum=NEW.tracking_number,
    shipdata_cosmisc_packnum_tracknum=NEW.package_tracking_number,
    shipdata_lastupdated=NEW.last_updated
  WHERE ((shipdata_cohead_number=OLD.so_number)
  AND (shipdata_shiphead_number=OLD.shipment_number)
  AND (shipdata_shipper=OLD.shipper)
  AND (shipdata_cosmisc_packnum_tracknum=OLD.package_tracking_number));

  CREATE OR REPLACE RULE "_DELETE" AS
  ON DELETE TO api.extshipmaint DO INSTEAD

  DELETE FROM shipdata 
  WHERE ((shipdata_cohead_number=OLD.so_number)
  AND (shipdata_shiphead_number=OLD.shipment_number)
  AND (shipdata_shipper=OLD.shipper)
  AND (shipdata_cosmisc_packnum_tracknum=OLD.package_tracking_number));
