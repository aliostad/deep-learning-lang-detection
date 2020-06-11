
-- Sale
SELECT dropIfExists('VIEW', 'api_sale', 'xtpos');
CREATE VIEW xtpos.api_sale
AS
  SELECT 
    salehead_number AS sale_number,
    CASE WHEN (salehead_type='S') THEN 'Sale'
         WHEN (salehead_type='Q') THEN 'Quote'
         WHEN (salehead_type='R') THEN 'Return'
         ELSE 'Error' 
    END AS type,
    CASE 
      WHEN (salehead_closed OR salehead_type IN ('S','R')) THEN
        salehead_closed
      ELSE
        xtpos.checkStatus(salehead_id)
    END AS closed,
    cust_number AS customer_number,
    c.cntct_number AS contact_number,
    c.cntct_honorific AS honorific,
    c.cntct_first_name AS first,
    c.cntct_middle AS middle,
    c.cntct_last_name AS last,
    c.cntct_suffix AS suffix,
    c.cntct_title AS job_title,
    c.cntct_phone AS voice,
    c.cntct_phone2 AS alternate,
    c.cntct_fax AS fax,
    c.cntct_email AS email,
    c.cntct_webaddr AS web,
    ''::text AS contact_change,
    a.addr_number AS address_number,
    a.addr_line1 AS address1,
    a.addr_line2 AS address2,
    a.addr_line3 AS address3,
    a.addr_city AS city,
    a.addr_state AS state,
    a.addr_postalcode AS postalcode,
    a.addr_country AS country,
    ''::text AS address_change,
    salehead_time AS date,
    salesrep_number AS sales_rep,
    salehead_notes AS notes,
    warehous_code AS site,
    terminal_number AS terminal,
    taxzone_code AS tax_zone,
    coalesce((sum(round(abs(saleitem_qty) * saleitem_unitprice,2))),0) AS subtotal,
    xtpos.saletax(salehead_id) AS tax,
    coalesce((sum(round((abs(saleitem_qty) * saleitem_unitprice), 2)) + abs(xtpos.saletax(salehead_id))),0) AS total
  FROM xtpos.salehead
    JOIN site() ON (salehead_warehous_id=warehous_id)
    JOIN xtpos.terminal ON (salehead_terminal_id=terminal_id)
    LEFT OUTER JOIN custinfo ON (salehead_cust_id=cust_id)
    LEFT OUTER JOIN cntct c ON (cust_cntct_id=c.cntct_id)
    LEFT OUTER JOIN addr a ON (cntct_addr_id=a.addr_id)
    LEFT OUTER JOIN salesrep ON (salehead_salesrep_id=salesrep_id)
    LEFT OUTER JOIN xtpos.saleitem ON (salehead_id=saleitem_salehead_id)
    LEFT OUTER JOIN taxzone ON (salehead_taxzone_id=taxzone_id)
  GROUP BY salehead_id, salehead_number,salehead_type,salehead_closed,cust_number,
    c.cntct_number,c.cntct_honorific,c.cntct_first_name,c.cntct_middle,
    c.cntct_last_name,c.cntct_suffix,c.cntct_title,c.cntct_phone,c.cntct_phone2,
    c.cntct_fax,c.cntct_email,c.cntct_webaddr,a.addr_number,a.addr_line1,a.addr_line2,
    a.addr_line3,a.addr_city,a.addr_state,a.addr_postalcode,a.addr_country,salehead_time,
    warehous_code,salesrep_number,terminal_number,salehead_notes,taxzone_code
  ORDER BY salehead_number;

GRANT ALL ON TABLE xtpos.api_sale TO xtrole;
COMMENT ON VIEW xtpos.api_sale IS 'Sale';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO xtpos.api_sale DO INSTEAD

  INSERT INTO xtpos.salehead (
    salehead_number,
    salehead_warehous_id,
    salehead_type,
    salehead_cust_id,
    salehead_time,
    salehead_terminal_id,
    salehead_notes,
    salehead_salesrep_id,
    salehead_taxzone_id )
  VALUES (
    NEW.sale_number,
    getWarehousId(NEW.site,'ACTIVE'),
    CASE WHEN (NEW.type='Sale') THEN 'S'
         WHEN (NEW.type='Quote') THEN 'Q'
         WHEN (NEW.type='Return') THEN 'R'
    END,
    getCustId(NEW.customer_number),
    now(),
    xtpos.getTerminalId(NEW.terminal),
    NEW.notes,
    getSalesrepId(NEW.sales_rep),
    getTaxzoneId(NEW.tax_zone)
  );

CREATE OR REPLACE RULE "_INSERT_CNTCT" AS
    ON INSERT TO xtpos.api_sale DO INSTEAD

  UPDATE custinfo SET
    cust_cntct_id=
      COALESCE(saveCntct(
        getCntctId(NEW.contact_number),
        NEW.contact_number,
        saveAddr(
          getAddrId(NEW.address_number),
          NEW.address_number,
          NEW.address1,
          NEW.address2,
          NEW.address3,
          NEW.city,
          NEW.state,
          NEW.postalcode,
          NEW.country,
          NEW.address_change),
        NEW.honorific,
        NEW.first,
        NEW.middle,
        NEW.last,
        NEW.suffix,
        NEW.voice,
        NEW.alternate,
        NEW.fax,
        NEW.email,
        NEW.web,
        NEW.job_title,
        NEW.contact_change ),cust_cntct_id)
  WHERE (cust_number=NEW.customer_number);

CREATE OR REPLACE RULE "_UPDATE" AS 
    ON UPDATE TO xtpos.api_sale DO INSTEAD

  UPDATE xtpos.salehead SET
    salehead_type=    
    CASE WHEN (NEW.type='Sale') THEN 'S'
         WHEN (NEW.type='Quote') THEN 'Q'
         WHEN (NEW.type='Return') THEN 'R'
         ELSE 'Error' 
    END,
    salehead_cust_id=getCustId(NEW.customer_number),
    salehead_time=now(), 
    salehead_terminal_id=xtpos.getTerminalId(NEW.terminal),
    salehead_notes=NEW.notes,
    salehead_salesrep_id=getSalesrepId(NEW.sales_rep),
    salehead_taxzone_id=getTaxzoneId(NEW.tax_zone)
  WHERE (salehead_number=OLD.sale_number);

CREATE OR REPLACE RULE "_UPDATE_CNTCT" AS
    ON UPDATE TO xtpos.api_sale DO INSTEAD

  UPDATE custinfo SET
    cust_cntct_id=
      COALESCE(saveCntct(
        getCntctId(NEW.contact_number),
        NEW.contact_number,
        saveAddr(
          getAddrId(NEW.address_number),
          NEW.address_number,
          NEW.address1,
          NEW.address2,
          NEW.address3,
          NEW.city,
          NEW.state,
          NEW.postalcode,
          NEW.country,
          NEW.address_change),
        NEW.honorific,
        NEW.first,
        NEW.middle,
        NEW.last,
        NEW.suffix,
        NEW.voice,
        NEW.alternate,
        NEW.fax,
        NEW.email,
        NEW.web,
        NEW.job_title,
        NEW.contact_change ),cust_cntct_id)
  WHERE (cust_number=NEW.customer_number);
           
CREATE OR REPLACE RULE "_DELETE" AS 
    ON DELETE TO xtpos.api_sale DO INSTEAD

  DELETE FROM xtpos.salehead WHERE (salehead_number=OLD.sale_number);
  

