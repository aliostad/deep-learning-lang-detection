  --Purchase Order View

  SELECT dropIfExists('VIEW', 'purchaseorder', 'api');
  CREATE OR REPLACE VIEW api.purchaseorder AS

  SELECT
    pohead_number::varchar AS order_number,
    pohead_orderdate AS order_date,
    terms_code AS terms,
    taxzone_code AS tax_zone,
    warehous_code AS receiving_site,
    pohead_agent_username AS purchasing_agent,
    vend_number AS vendor_number,
    COALESCE(vendaddr_code,'MAIN') AS alt_address,
    pohead_fob AS fob,
    pohead_shipvia AS ship_via,
    curr_abbr AS currency,
    (SELECT COALESCE(SUM(tax), 0.00) AS tax
     FROM (SELECT ROUND(SUM(taxdetail_tax),2) AS tax
           FROM tax
            JOIN calculateTaxDetailSummary('PO', pohead_id, 'T') ON (taxdetail_tax_id=tax_id)
           GROUP BY tax_id) AS data) AS tax,
    pohead_freight AS freight,
    pohead_comments AS notes,
    pohead_dropship AS dropship,
    vc.cntct_number AS vend_contact_number,
    pohead_vend_cntct_honorific AS vend_cntct_honorific,
    pohead_vend_cntct_first_name AS vend_cntct_first_name,
    pohead_vend_cntct_middle AS vend_cntct_middle,
    pohead_vend_cntct_last_name AS vend_cntct_last_name,
    pohead_vend_cntct_suffix AS vend_cntct_suffix,
    pohead_vend_cntct_phone AS vend_cntct_phone,
    pohead_vend_cntct_title AS vend_cntct_title,
    pohead_vend_cntct_fax AS vend_cntct_fax,
    pohead_vend_cntct_email AS vend_cntct_email,
    pohead_vendaddress1 AS vendaddress1,
    pohead_vendaddress2 AS vendaddress2,
    pohead_vendaddress3 AS vendaddress3,
    pohead_vendcity AS vendcity,
    pohead_vendstate AS vendstate,
    pohead_vendzipcode AS vendzipcode,
    pohead_vendcountry AS vendcountry,
    sc.cntct_number AS shipto_contact_number,
    pohead_shipto_cntct_honorific AS shipto_cntct_honorific,
    pohead_shipto_cntct_first_name AS shipto_cntct_first_name,
    pohead_shipto_cntct_middle AS shipto_cntct_middle,
    pohead_shipto_cntct_last_name AS shipto_cntct_last_name,
    pohead_shipto_cntct_suffix AS shipto_cntct_suffix,
    pohead_shipto_cntct_phone AS shipto_cntct_phone,
    pohead_shipto_cntct_title AS shipto_cntct_title,
    pohead_shipto_cntct_fax AS shipto_cntct_fax,
    pohead_shipto_cntct_email AS shipto_cntct_email,
    addr_number AS shiptoaddress_number,
    pohead_shiptoaddress1 AS shiptoaddress1,
    pohead_shiptoaddress2 AS shiptoaddress2,
    pohead_shiptoaddress3 AS shiptoaddress3,
    pohead_shiptocity AS shiptocity,
    pohead_shiptostate AS shiptostate,
    pohead_shiptozipcode AS shiptozipcode,
    pohead_shiptocountry AS shiptocountry,
    cohead_number AS sales_order_number
  FROM pohead
    LEFT OUTER JOIN cntct vc ON (pohead_vend_cntct_id=vc.cntct_id)
    LEFT OUTER JOIN cntct sc ON (pohead_shipto_cntct_id=sc.cntct_id)
    LEFT OUTER JOIN addr     ON (pohead_shiptoaddress_id=addr_id)
    LEFT OUTER JOIN terms ON (pohead_terms_id=terms_id)
    LEFT OUTER JOIN taxzone ON (pohead_taxzone_id=taxzone_id)
    LEFT OUTER JOIN whsinfo ON (pohead_warehous_id=warehous_id)
    LEFT OUTER JOIN vendaddrinfo ua ON (pohead_vendaddr_id=vendaddr_id)
    LEFT OUTER JOIN cohead ON (pohead_cohead_id=cohead_id)
    JOIN vendinfo ON (pohead_vend_id=vend_id)
    JOIN curr_symbol ON (pohead_curr_id=curr_id)
  ORDER BY pohead_number;

GRANT ALL ON TABLE api.purchaseorder TO xtrole;
COMMENT ON VIEW api.purchaseorder IS 'Purchase Order';

  --Rules

  CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.purchaseorder DO INSTEAD

  INSERT INTO pohead (
    pohead_number,
    pohead_orderdate,
    pohead_status,
    pohead_terms_id,
    pohead_taxzone_id,
    pohead_warehous_id,
    pohead_agent_username,
    pohead_vend_id,
    pohead_vendaddr_id,
    pohead_fob,
    pohead_shipvia,
    pohead_curr_id,
    pohead_freight,
    pohead_comments,
    pohead_dropship,
    pohead_vend_cntct_id,
    pohead_vend_cntct_honorific,
    pohead_vend_cntct_first_name,
    pohead_vend_cntct_middle,
    pohead_vend_cntct_last_name,
    pohead_vend_cntct_suffix,
    pohead_vend_cntct_phone,
    pohead_vend_cntct_title,
    pohead_vend_cntct_fax,
    pohead_vend_cntct_email,
    pohead_vendaddress1,
    pohead_vendaddress2,
    pohead_vendaddress3,
    pohead_vendcity,
    pohead_vendstate,
    pohead_vendzipcode,
    pohead_vendcountry,
    pohead_shipto_cntct_id,
    pohead_shipto_cntct_honorific,
    pohead_shipto_cntct_first_name,
    pohead_shipto_cntct_middle,
    pohead_shipto_cntct_last_name,
    pohead_shipto_cntct_suffix,
    pohead_shipto_cntct_phone,
    pohead_shipto_cntct_title,
    pohead_shipto_cntct_fax,
    pohead_shipto_cntct_email,
    pohead_shiptoaddress_id,
    pohead_shiptoaddress1,
    pohead_shiptoaddress2,
    pohead_shiptoaddress3,
    pohead_shiptocity,
    pohead_shiptostate,
    pohead_shiptozipcode,
    pohead_shiptocountry,
    pohead_cohead_id
    )
  SELECT
    NEW.order_number,
    COALESCE(NEW.order_date,current_date),
    'U',
    COALESCE(getTermsId(NEW.terms),vend_terms_id),
    COALESCE(getTaxzoneId(NEW.tax_zone),vend_taxzone_id),
    COALESCE(getWarehousId(NEW.receiving_site,'ALL'),fetchPrefwarehousid()),
    COALESCE(NEW.purchasing_agent,getEffectiveXtUser()),
    getVendId(NEW.vendor_number),
    CASE WHEN (NEW.alt_address='MAIN') THEN NULL
      ELSE getVendAddrId(NEW.vendor_number, NEW.alt_address) END,
    COALESCE(NEW.fob,
      CASE WHEN (vend_fobsource='W') THEN (
        SELECT warehous_fob
        FROM whsinfo
        WHERE (warehous_id=COALESCE(getWarehousId(NEW.receiving_site,'ALL'),fetchPrefWarehousId()))
      )
      ELSE vend_fob END),
    COALESCE(NEW.ship_via,vend_shipvia),
    COALESCE(getCurrId(NEW.currency),vend_curr_id),
    COALESCE(NEW.freight,0),
    NEW.notes,
    COALESCE(NEW.dropship, FALSE),
    getCntctId(NEW.vend_contact_number),
    COALESCE(NEW.vend_cntct_honorific,''),
    COALESCE(NEW.vend_cntct_first_name,''),
    COALESCE(NEW.vend_cntct_middle,''),
    COALESCE(NEW.vend_cntct_last_name,''),
    COALESCE(NEW.vend_cntct_suffix,''),
    COALESCE(NEW.vend_cntct_phone,''),
    COALESCE(NEW.vend_cntct_title,''),
    COALESCE(NEW.vend_cntct_fax,''),
    COALESCE(NEW.vend_cntct_email,''),
    COALESCE(NEW.vendaddress1,''),
    COALESCE(NEW.vendaddress2,''),
    COALESCE(NEW.vendaddress3,''),
    COALESCE(NEW.vendcity,''),
    COALESCE(NEW.vendstate,''),
    COALESCE(NEW.vendzipcode,''),
    COALESCE(NEW.vendcountry,''),
    getCntctId(NEW.shipto_contact_number),
    COALESCE(NEW.shipto_cntct_honorific,''),
    COALESCE(NEW.shipto_cntct_first_name,''),
    COALESCE(NEW.shipto_cntct_middle,''),
    COALESCE(NEW.shipto_cntct_last_name,''),
    COALESCE(NEW.shipto_cntct_suffix,''),
    COALESCE(NEW.shipto_cntct_phone,''),
    COALESCE(NEW.shipto_cntct_title,''),
    COALESCE(NEW.shipto_cntct_fax,''),
    COALESCE(NEW.shipto_cntct_email,''),
    getAddrId(NEW.shiptoaddress_number),
    COALESCE(NEW.shiptoaddress1,''),
    COALESCE(NEW.shiptoaddress2,''),
    COALESCE(NEW.shiptoaddress3,''),
    COALESCE(NEW.shiptocity,''),
    COALESCE(NEW.shiptostate,''),
    COALESCE(NEW.shiptozipcode,''),
    COALESCE(NEW.shiptocountry,''),
    getCoheadId(NEW.sales_order_number)
  FROM vendinfo
  WHERE (vend_id=getVendId(NEW.vendor_number));
 
  CREATE OR REPLACE RULE "_UPDATE" AS
  ON UPDATE TO api.purchaseorder DO INSTEAD

  UPDATE pohead SET
    pohead_terms_id=getTermsId(NEW.terms),
    pohead_taxzone_id=getTaxzoneId(NEW.tax_zone),
    pohead_warehous_id=getWarehousId(NEW.receiving_site,'ALL'),
    pohead_agent_username=NEW.purchasing_agent,
    pohead_vendaddr_id=
      CASE WHEN (NEW.alt_address='MAIN') THEN NULL
      ELSE getVendAddrId(OLD.vendor_number, NEW.alt_address) END,
    pohead_fob=NEW.fob,
    pohead_shipvia=NEW.ship_via,
    pohead_curr_id=getCurrId(NEW.currency),
    pohead_freight=NEW.freight,
    pohead_comments=NEW.notes,
    pohead_dropship=NEW.dropship,
    pohead_vend_cntct_id=getCntctId(NEW.vend_contact_number),
    pohead_vend_cntct_honorific=NEW.vend_cntct_honorific,
    pohead_vend_cntct_first_name=NEW.vend_cntct_first_name,
    pohead_vend_cntct_middle=NEW.vend_cntct_middle,
    pohead_vend_cntct_last_name=NEW.vend_cntct_last_name,
    pohead_vend_cntct_suffix=NEW.vend_cntct_suffix,
    pohead_vend_cntct_phone=NEW.vend_cntct_phone,
    pohead_vend_cntct_title=NEW.vend_cntct_title,
    pohead_vend_cntct_fax=NEW.vend_cntct_fax,
    pohead_vend_cntct_email=NEW.vend_cntct_email,
    pohead_vendaddress1=NEW.vendaddress1,
    pohead_vendaddress2=NEW.vendaddress2,
    pohead_vendaddress3=NEW.vendaddress3,
    pohead_vendcity=NEW.vendcity,
    pohead_vendstate=NEW.vendstate,
    pohead_vendzipcode=NEW.vendzipcode,
    pohead_vendcountry=NEW.vendcountry,
    pohead_shipto_cntct_id=getCntctId(NEW.shipto_contact_number),
    pohead_shipto_cntct_honorific=NEW.shipto_cntct_honorific,
    pohead_shipto_cntct_first_name=NEW.shipto_cntct_first_name,
    pohead_shipto_cntct_middle=NEW.shipto_cntct_middle,
    pohead_shipto_cntct_last_name=NEW.shipto_cntct_last_name,
    pohead_shipto_cntct_suffix=NEW.shipto_cntct_suffix,
    pohead_shipto_cntct_phone=NEW.shipto_cntct_phone,
    pohead_shipto_cntct_title=NEW.shipto_cntct_title,
    pohead_shipto_cntct_fax=NEW.shipto_cntct_fax,
    pohead_shipto_cntct_email=NEW.shipto_cntct_email,
    pohead_shiptoaddress_id=getAddrId(NEW.shiptoaddress_number),
    pohead_shiptoaddress1=NEW.shiptoaddress1,
    pohead_shiptoaddress2=NEW.shiptoaddress2,
    pohead_shiptoaddress3=NEW.shiptoaddress3,
    pohead_shiptocity=NEW.shiptocity,
    pohead_shiptostate=NEW.shiptostate,
    pohead_shiptozipcode=NEW.shiptozipcode,
    pohead_shiptocountry=NEW.shiptocountry,
    pohead_cohead_id=getCoheadId(NEW.sales_order_number)
  WHERE (pohead_number=OLD.order_number);

  CREATE OR REPLACE RULE "_DELETE" AS
  ON DELETE TO api.purchaseorder DO INSTEAD

  SELECT deletepo(pohead_id)
  FROM pohead
  WHERE (pohead_number=OLD.order_number);
