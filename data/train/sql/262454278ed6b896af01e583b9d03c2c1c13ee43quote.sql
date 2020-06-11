-- Quote

SELECT dropIfExists('VIEW', 'quote', 'api');
CREATE VIEW api.quote
AS
   SELECT 
     quhead_number::varchar AS quote_number,
     warehous_code AS site,
     quhead_quotedate AS quote_date,
     quhead_packdate AS pack_date,
     saletype_code AS sale_type,
     salesrep_number AS sales_rep,
     quhead_commission AS commission,
     taxzone_code AS tax_zone,
     taxtype_name AS tax_type,
     terms_code AS terms,
     prj_number AS project_number,
     COALESCE(cust_number,prospect_number) AS customer_number,
     quhead_billtoname AS billto_name,
     quhead_billtoaddress1 AS billto_address1,
     quhead_billtoaddress2 AS billto_address2,
     quhead_billtoaddress3 AS billto_address3,
     quhead_billtocity AS billto_city,
     quhead_billtostate AS billto_state,
     quhead_billtozip AS billto_postal_code,
     quhead_billtocountry AS billto_country,
     shipto_num AS shipto_number,
     quhead_shiptoname AS shipto_name,
     quhead_shiptophone AS shipto_phone,
     quhead_shiptoaddress1 AS shipto_address1,
     quhead_shiptoaddress2 AS shipto_address2,
     quhead_shiptoaddress3 AS shipto_address3,
     quhead_shiptocity AS shipto_city,
     quhead_shiptostate AS shipto_state,
     quhead_shiptozipcode AS shipto_postal_code,
     quhead_shiptocountry AS shipto_country,
     shipzone_name AS shipto_shipzone,
     quhead_custponumber AS cust_po_number,
     quhead_fob AS fob,
     quhead_shipvia AS ship_via,
     curr_abbr AS currency,
     quhead_misc_descrip AS misc_charge_description,
     CASE
       WHEN (quhead_misc_accnt_id IS NULL) THEN
         NULL
       ELSE
         formatglaccount(quhead_misc_accnt_id) 
     END AS misc_account_number,
     quhead_misc AS misc_charge,
     quhead_freight AS freight,
     quhead_ordercomments AS order_notes,
     quhead_shipcomments AS shipping_notes,
     false AS add_to_packing_list_batch,
     quhead_expire AS expire_date,
     CASE
       WHEN quhead_status='C' THEN
         'Converted'
       ELSE
         'Open'
     END AS status
   FROM curr_symbol,quhead
     LEFT OUTER JOIN whsinfo ON (quhead_warehous_id=warehous_id)
     LEFT OUTER JOIN prj ON (quhead_prj_id=prj_id)
     LEFT OUTER JOIN shiptoinfo ON (quhead_shipto_id=shipto_id)
     LEFT OUTER JOIN taxzone ON (quhead_taxzone_id=taxzone_id)
     LEFT OUTER JOIN taxtype ON (quhead_taxtype_id=taxtype_id)
     LEFT OUTER JOIN custinfo ON (quhead_cust_id=cust_id)
     LEFT OUTER JOIN prospect ON (quhead_cust_id=prospect_id)
     LEFT OUTER JOIN salesrep ON (quhead_salesrep_id=salesrep_id)
     LEFT OUTER JOIN terms ON (quhead_terms_id=terms_id)
     LEFT OUTER JOIN saletype ON (quhead_saletype_id=saletype_id)
     LEFT OUTER JOIN shipzone ON (quhead_shipzone_id=shipzone_id)
   WHERE (quhead_curr_id=curr_id);

GRANT ALL ON TABLE api.quote TO xtrole;
COMMENT ON VIEW api.quote IS 'Quote';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.quote DO INSTEAD

  INSERT INTO quhead (
    quhead_number,
    quhead_cust_id,
    quhead_custponumber,
    quhead_quotedate,
    quhead_warehous_id,
    quhead_shipto_id,
    quhead_shiptoname,
    quhead_shiptoaddress1,
    quhead_shiptoaddress2,
    quhead_shiptoaddress3,
    quhead_salesrep_id,
    quhead_terms_id,
    quhead_fob,
    quhead_shipvia,
    quhead_shiptocity,
    quhead_shiptostate,
    quhead_shiptozipcode,
    quhead_freight,
    quhead_misc,
    quhead_ordercomments,
    quhead_shipcomments,
    quhead_shiptophone,
    quhead_billtoname,
    quhead_billtoaddress1,
    quhead_billtoaddress2,
    quhead_billtoaddress3,
    quhead_billtocity,
    quhead_billtostate,
    quhead_billtozip,
    quhead_misc_accnt_id,
    quhead_misc_descrip,
    quhead_commission,
    quhead_packdate,
    quhead_prj_id,
    quhead_billtocountry,
    quhead_shiptocountry,
    quhead_curr_id,
    quhead_taxzone_id,
    quhead_taxtype_id,
    quhead_imported,
    quhead_expire,
    quhead_status,
    quhead_saletype_id,
    quhead_shipzone_id
    )
  VALUES (
    NEW.quote_number,
    getCustId(NEW.customer_number,true),
    NEW.cust_po_number,
    NEW.quote_date,
    getWarehousId(NEW.site,'SHIPPING'),
    getShiptoId(NEW.customer_number,NEW.shipto_number),
    NEW.shipto_name,
    NEW.shipto_address1,
    NEW.shipto_address2,
    NEW.shipto_address3,
    getSalesRepId(NEW.sales_rep),
    getTermsId(NEW.terms),
    NEW.fob,
    NEW.ship_via,
    NEW.shipto_city,
    NEW.shipto_state,
    NEW.shipto_postal_code,
    NEW.freight,
    NEW.misc_charge,
    NEW.order_notes,
    NEW.shipping_notes,
    NEW.shipto_phone,
    NEW.billto_name,
    NEW.billto_address1,
    NEW.billto_address2,
    NEW.billto_address3,
    NEW.billto_city,
    NEW.billto_state,
    NEW.billto_postal_code,
    getGlAccntId(NEW.misc_account_number),
    NEW.misc_charge_description,
    NEW.commission,
    NEW.pack_date,
    getPrjId(NEW.project_number),
    NEW.billto_country,
    NEW.shipto_country,
    getCurrId(NEW.currency),
    getTaxZoneId(NEW.tax_zone),
    getTaxTypeId(NEW.tax_type),
    true,
    NEW.expire_date,
    CASE
      WHEN NEW.status = 'Converted' THEN
        'C'
      ELSE
        'O'
    END,
    getSaleTypeId(NEW.sale_type),
    getShipZoneId(NEW.shipto_shipzone)
);

CREATE OR REPLACE RULE "_UPDATE" AS 
    ON UPDATE TO api.quote DO INSTEAD

  UPDATE quhead SET
    quhead_number=OLD.quote_number,
    quhead_cust_id=getCustId(NEW.customer_number,true),
    quhead_custponumber=NEW.cust_po_number,
    quhead_quotedate=NEW.quote_date,
    quhead_warehous_id=getWarehousId(NEW.site,'SHIPPING'),
    quhead_shipto_id=getShiptoId(NEW.customer_number,NEW.shipto_number),
    quhead_shiptoname=NEW.shipto_name,
    quhead_shiptoaddress1=NEW.shipto_address1,
    quhead_shiptoaddress2=NEW.shipto_address2,
    quhead_shiptoaddress3=NEW.shipto_address3,
    quhead_salesrep_id=getSalesRepId(NEW.sales_rep),
    quhead_terms_id=getTermsId(NEW.terms),
    quhead_fob=NEW.fob,
    quhead_shipvia=NEW.ship_via,
    quhead_shiptocity=NEW.shipto_city,
    quhead_shiptostate=NEW.shipto_state,
    quhead_shiptozipcode=NEW.shipto_postal_code,
    quhead_freight=NEW.freight,
    quhead_misc=NEW.misc_charge,
    quhead_ordercomments=NEW.order_notes,
    quhead_shipcomments=NEW.shipping_notes,
    quhead_shiptophone=NEW.shipto_phone,
    quhead_billtoname=NEW.billto_name,
    quhead_billtoaddress1=NEW.billto_address1,
    quhead_billtoaddress2=NEW.billto_address2,
    quhead_billtoaddress3=NEW.billto_address3,
    quhead_billtocity=NEW.billto_city,
    quhead_billtostate=NEW.billto_state,
    quhead_billtozip=NEW.billto_postal_code,
    quhead_misc_accnt_id=getGlAccntId(NEW.misc_account_number),
    quhead_misc_descrip=NEW.misc_charge_description,
    quhead_commission=NEW.commission,
    quhead_packdate=NEW.pack_date,
    quhead_prj_id=getPrjId(NEW.project_number),
    quhead_billtocountry=NEW.billto_country,
    quhead_shiptocountry=NEW.shipto_country,
    quhead_curr_id=getCurrId(NEW.currency),
    quhead_taxzone_id=getTaxZoneId(NEW.tax_zone),
    quhead_taxtype_id=getTaxTypeId(NEW.tax_type),
    quhead_expire=NEW.expire_date,
    quhead_saletype_id=getSaleTypeId(NEW.sale_type),
    quhead_shipzone_id=getShipZoneId(NEW.shipto_shipzone)
  WHERE (quhead_number=OLD.quote_number);
           
CREATE OR REPLACE RULE "_DELETE" AS 
    ON DELETE TO api.quote DO INSTEAD

  SELECT deletequote(quhead_id,OLD.quote_number)
  FROM quhead
  WHERE (quhead_number=OLD.quote_number);
