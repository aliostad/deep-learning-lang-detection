--Vendor Address View

SELECT dropIfExists('VIEW', 'vendoraddress', 'api');
CREATE OR REPLACE VIEW api.vendoraddress AS
 
SELECT 
  vend_number::VARCHAR AS vendor_number,
  vend_name AS vendor_name,
  vendaddr_code::VARCHAR AS vendor_address_number,
  vendaddr_name AS vendor_address_name,
  addr_number AS address_number,
  addr_line1 AS address1,
  addr_line2 AS address2,
  addr_line3 AS address3,
  addr_city AS city,
  addr_state AS state,
  addr_postalcode AS postalcode,
  addr_country AS country,
  (''::TEXT) AS address_change,
  cntct_number AS contact_number,
  cntct_honorific AS contact_honorific,
  cntct_first_name AS contact_first,
  cntct_middle AS contact_middle,   
  cntct_last_name AS contact_last,
  cntct_suffix AS contact_suffix,
  cntct_title AS contact_job_title,
  cntct_phone AS contact_voice,
  cntct_phone2 AS contact_alternate,
  cntct_fax AS contact_fax,
  cntct_email AS contact_email,
  cntct_webaddr AS contact_web,
  (''::TEXT) AS contact_change,
  vendaddr_comments AS notes
FROM
  vendaddrinfo
    LEFT OUTER JOIN vendinfo ON (vend_id=vendaddr_vend_id)
    LEFT OUTER JOIN addr ON (vendaddr_addr_id=addr_id)
    LEFT OUTER JOIN cntct ON (vendaddr_cntct_id=cntct_id)
ORDER BY vendaddr_code;

GRANT ALL ON TABLE api.vendoraddress TO xtrole;
COMMENT ON VIEW api.vendoraddress IS 'vendor address';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.vendoraddress DO INSTEAD

INSERT INTO vendaddrinfo (
  vendaddr_vend_id,
  vendaddr_code,
  vendaddr_name,
  vendaddr_comments,
  vendaddr_cntct_id,
  vendaddr_addr_id )
VALUES (
  getVendId(NEW.vendor_number),
  COALESCE(NEW.vendor_address_number, ''),
  COALESCE(NEW.vendor_address_name, ''),
  COALESCE(NEW.notes, ''),
  saveCntct( getCntctId(NEW.contact_number),
             NEW.contact_number,
             saveAddr( getAddrId(NEW.address_number),
                       NEW.address_number,
                       NEW.address1,
                       NEW.address2,
                       NEW.address3,
                       NEW.city,
                       NEW.state,
                       NEW.postalcode,
                       NEW.country,
                       NEW.address_change ),
             NEW.contact_honorific,
             NEW.contact_first,
             NEW.contact_middle,
             NEW.contact_last,
             NEW.contact_suffix,
             NEW.contact_voice,
             NEW.contact_alternate,
             NEW.contact_fax,
             NEW.contact_email,
             NEW.contact_web,
             NEW.contact_job_title,
             NEW.contact_change ),
  saveAddr( getAddrId(NEW.address_number),
            NEW.address_number,
            NEW.address1,
            NEW.address2,
            NEW.address3,
            NEW.city,
            NEW.state,
            NEW.postalcode,
            NEW.country,
            NEW.address_change ) );

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.vendoraddress DO INSTEAD

UPDATE vendaddrinfo SET
  vendaddr_vend_id=getVendId(NEW.vendor_number),
  vendaddr_code=NEW.vendor_address_number,
  vendaddr_name=NEW.vendor_address_name,
  vendaddr_comments=NEW.notes,
  vendaddr_cntct_id=
    saveCntct( getCntctId(NEW.contact_number),
               NEW.contact_number,
               saveAddr( getAddrId(NEW.address_number),
                         NEW.address_number,
                         NEW.address1,
                         NEW.address2,
                         NEW.address3,
                         NEW.city,
                         NEW.state,
                         NEW.postalcode,
                         NEW.country,
                         NEW.address_change ),
               NEW.contact_honorific,
               NEW.contact_first,
               NEW.contact_middle,
               NEW.contact_last,
               NEW.contact_suffix,
               NEW.contact_voice,
               NEW.contact_alternate,
               NEW.contact_fax,
               NEW.contact_email,
               NEW.contact_web,
               NEW.contact_job_title,
               NEW.contact_change ),
  vendaddr_addr_id=
    saveAddr( getAddrId(NEW.address_number),
              NEW.address_number,
              NEW.address1,
              NEW.address2,
              NEW.address3,
              NEW.city,
              NEW.state,
              NEW.postalcode,
              NEW.country,
              NEW.address_change )
WHERE vendaddr_id=getVendAddrId(OLD.vendor_number, OLD.vendor_address_number);

CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.vendoraddress DO INSTEAD

SELECT deletevendoraddress(getVendAddrId(OLD.vendor_number, OLD.vendor_address_number));
