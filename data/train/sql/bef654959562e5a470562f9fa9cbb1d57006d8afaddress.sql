  --Address View

SELECT dropIfExists('VIEW', 'address', 'api');
  CREATE OR REPLACE VIEW api.address AS
 
  SELECT 
    addr_number::varchar AS address_number,
    addr_line1 AS address1,
    addr_line2 AS address2,
    addr_line3 AS address3,
    addr_city AS city,
    addr_state AS state,
    addr_postalcode AS postal_code,
    addr_country AS country,
    addr_active AS active,
    addr_notes AS notes,
    ''::TEXT AS change       
  FROM
    addr;

GRANT ALL ON TABLE api.address TO xtrole;
COMMENT ON VIEW api.address IS 'Address';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.address DO INSTEAD

SELECT    saveAddr(
	    NULL,
            NEW.address_number,
            NEW.address1,
            NEW.address2,
            NEW.address3,
            NEW.city,
            NEW.state,
            NEW.postal_code,
            NEW.country,
            COALESCE(NEW.active,TRUE),
            NEW.notes,
            NULL);

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.address DO INSTEAD

SELECT saveAddr(
            getAddrId(NEW.address_number),
            NEW.address_number,
            NEW.address1,
            NEW.address2,
            NEW.address3,
            NEW.city,
            NEW.state,
            NEW.postal_code,
            NEW.country,
            NEW.active,
            NEW.notes,
            NEW.change);

CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.address DO INSTEAD

SELECT deleteAddress(getAddrId(OLD.address_number));
