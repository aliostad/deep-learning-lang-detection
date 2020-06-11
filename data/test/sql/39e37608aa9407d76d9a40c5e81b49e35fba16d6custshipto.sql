-- Customer Shipto

SELECT dropIfExists('VIEW', 'custshipto', 'api');
CREATE VIEW api.custshipto
AS
   SELECT
     cust_number::varchar AS customer_number,
     shipto_num::varchar AS shipto_number,
     shipto_active AS active,
     shipto_name AS name,
     shipto_default AS default_flag,
     addr_number AS address_number,
     addr_line1 AS address1,
     addr_line2 AS address2,
     addr_line3 AS address3,
     addr_city AS city,
     addr_state AS state,
     addr_postalcode AS postal_code,
     addr_country AS country,
     (''::text) AS address_change,
     cntct_number AS contact_number,
     cntct_honorific AS honorific,
     cntct_first_name AS first,
     cntct_middle AS middle,
     cntct_last_name AS last,
     cntct_suffix AS suffix,
     cntct_title AS job_title,
     cntct_phone AS phone,
     cntct_fax AS fax,
     cntct_email AS email,
     (''::text) AS contact_change,
     salesrep_number AS sales_rep,
     (shipto_commission * 100.0) AS commission,
     shipzone_name AS zone,
     taxzone_code AS tax_zone,
     shipto_shipvia AS ship_via,
     shipform_name AS ship_form,
     shipchrg_name AS shipping_charges,
     CASE
       WHEN shipto_ediprofile_id = -1 THEN
         'No EDI'
       WHEN shipto_ediprofile_id = -2 THEN
         'Use Customer Master'
       ELSE
         getEdiProfileName(shipto_ediprofile_id)
     END AS edi_profile,
     shipto_comments AS general_notes,
     shipto_shipcomments AS shipping_notes
     FROM custinfo, shiptoinfo
  LEFT OUTER JOIN shipchrg ON (shipto_shipchrg_id=shipchrg_id)
  LEFT OUTER JOIN cntct ON (shipto_cntct_id=cntct_id)
  LEFT OUTER JOIN addr ON (shipto_addr_id=addr_id)
  LEFT OUTER JOIN taxzone ON (shipto_taxzone_id=taxzone_id)
  LEFT OUTER JOIN shipzone ON (shipto_shipzone_id=shipzone_id)
  LEFT OUTER JOIN salesrep ON (shiptoinfo.shipto_salesrep_id = salesrep_id)
  ,shipform
     WHERE ((cust_id=shipto_cust_id)
     AND (cust_shipform_id=shipform_id));

GRANT ALL ON TABLE api.custshipto TO xtrole;
COMMENT ON VIEW api.custshipto IS 'Customer Shipto Address';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.custshipto DO INSTEAD

  INSERT INTO shiptoinfo (
    shipto_cust_id,
    shipto_name,
    shipto_salesrep_id,
    shipto_comments,
    shipto_shipcomments,
    shipto_shipzone_id,
    shipto_shipvia,
    shipto_commission,
    shipto_shipform_id,
    shipto_shipchrg_id,
    shipto_active,
    shipto_default,
    shipto_num,
    shipto_ediprofile_id,
    shipto_cntct_id,
    shipto_addr_id,
    shipto_taxzone_id
    )
  VALUES (
    getCustId(NEW.customer_number),
    COALESCE(NEW.name,''),
    COALESCE(getSalesRepId(NEW.sales_rep),(
      SELECT cust_salesrep_id
      FROM custinfo
      WHERE (cust_id=getCustId(NEW.customer_number)))),
    COALESCE(NEW.general_notes,''),
    COALESCE(NEW.shipping_notes,''),
    getShipZoneId(NEW.zone),
    COALESCE(NEW.ship_via,(
      SELECT cust_shipvia
      FROM custinfo
      WHERE (cust_id=getCustId(NEW.customer_number)))),
    COALESCE((NEW.commission / 100.0),0),
    COALESCE(getShipFormId(NEW.ship_form),(
      SELECT cust_shipform_id
      FROM custinfo
      WHERE (cust_id=getCustId(NEW.customer_number)))),
    COALESCE(getShipChrgId(NEW.shipping_charges),(
      SELECT cust_shipchrg_id
      FROM custinfo
      WHERE (cust_id=getCustId(NEW.customer_number)))),
    COALESCE(NEW.active,true),
    COALESCE(NEW.default_flag,false),
    COALESCE(NEW.shipto_number,CAST((
      SELECT (COALESCE(MAX(CAST(shipto_num AS INTEGER)), 0) + 1)
      FROM shiptoinfo
      WHERE (shipto_cust_id=getCustId(NEW.customer_number))
      AND  (shipto_num~'^[0-9]*$')) AS TEXT)),
    CASE
      WHEN NEW.edi_profile = 'No EDI' THEN
        -1
      WHEN NEW.edi_profile = 'Use Customer Master' THEN
        -2
      ELSE
        getEdiProfileId(NEW.edi_profile)
    END,
    saveCntct(
      getCntctId(NEW.contact_number),
      NEW.contact_number,
      NULL,
      NEW.honorific,
      NEW.first,
      NEW.middle,
      NEW.last,
      NEW.suffix,
      NEW.phone,
      NULL,
      NEW.fax,
      NEW.email,
      NULL,
      NEW.job_title,
      NEW.contact_change),
    saveAddr(
      getAddrId(NEW.address_number),
      NEW.address_number,
      NEW.address1,
      NEW.address2,
      NEW.address3,
      NEW.city,
      NEW.state,
      NEW.postal_code,
      NEW.country,
      NEW.address_change),
    COALESCE(getTaxZoneId(NEW.tax_zone),(
      SELECT cust_taxzone_id
      FROM custinfo
      WHERE (cust_id=getCustId(NEW.customer_number)))));

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.custshipto DO INSTEAD

  UPDATE shiptoinfo SET
    shipto_cust_id=getCustId(NEW.customer_number),
    shipto_name=NEW.name,
    shipto_salesrep_id=getSalesRepId(NEW.sales_rep),
    shipto_comments=NEW.general_notes,
    shipto_shipcomments=NEW.shipping_notes,
    shipto_shipzone_id=getShipZoneId(NEW.zone),
    shipto_shipvia=NEW.ship_via,
    shipto_commission=(NEW.commission / 100),
    shipto_shipform_id=getShipFormId(NEW.ship_form),
    shipto_shipchrg_id=getShipChrgId(NEW.shipping_charges),
    shipto_active=NEW.active,
    shipto_default=NEW.default_flag,
    shipto_num=OLD.shipto_number,
    shipto_ediprofile_id=
    CASE
      WHEN NEW.edi_profile = 'No EDI' THEN
        -1
      WHEN NEW.edi_profile = 'Use Customer Master' THEN
        -2
      ELSE
        getEdiProfileId(NEW.edi_profile)
    END,
    shipto_cntct_id=saveCntct(
      getCntctId(NEW.contact_number),
      NEW.contact_number,
      NULL,
      NEW.honorific,
      NEW.first,
      NEW.middle,
      NEW.last,
      NEW.suffix,
      NEW.phone,
      NULL,
      NEW.fax,
      NEW.email,
      NULL,
      NEW.job_title,
      NEW.contact_change),
    shipto_addr_id=saveAddr(
      getAddrId(NEW.address_number),
      NEW.address_number,
      NEW.address1,
      NEW.address2,
      NEW.address3,
      NEW.city,
      NEW.state,
      NEW.postal_code,
      NEW.country,
      NEW.address_change),
    shipto_taxzone_id=getTaxZoneId(NEW.tax_zone)
  WHERE  (shipto_id=getShiptoId(OLD.customer_number,OLD.shipto_number));

CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.custshipto DO INSTEAD

  SELECT deleteShipto(getShiptoId(OLD.customer_number,OLD.shipto_number));
