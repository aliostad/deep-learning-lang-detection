  --Contact View

SELECT dropIfExists('VIEW', 'contact', 'api');
  CREATE OR REPLACE VIEW api.contact AS
 
  SELECT 
    cntct_number::varchar AS contact_number,
    cntct_honorific AS honorific,
    cntct_first_name AS first,
    cntct_middle AS middle,
    cntct_last_name AS last,
    cntct_suffix AS suffix,
    cntct_initials AS initials,
    crmacct_number AS crm_account,
    cntct_active AS active,
    cntct_title AS job_title,
    cntct_phone AS voice,
    cntct_phone2 AS alternate,
    cntct_fax AS fax,
    cntct_email AS email,
    cntct_webaddr AS web,
    ''::TEXT AS contact_change, 
    addr_number AS address_number,
    addr_line1 AS address1,
    addr_line2 AS address2,
    addr_line3 AS address3,
    addr_city AS city,
    addr_state AS state,
    addr_postalcode AS postal_code,
    addr_country AS country,
    cntct_notes AS notes, 
    ''::TEXT AS address_change
  FROM
    cntct
      LEFT OUTER JOIN addr ON (cntct_addr_id=addr_id)
      LEFT OUTER JOIN crmacct ON (cntct_crmacct_id=crmacct_id);

GRANT ALL ON TABLE api.contact TO xtrole;
COMMENT ON VIEW api.contact IS 'Contact';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.contact DO INSTEAD

SELECT saveCntct(
	  NULL,
          NEW.contact_number,
          getCrmAcctid(NEW.crm_account),
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
          NEW.honorific,
          NEW.first,
          NEW.middle,
          NEW.last,
          NEW.suffix,
          NEW.initials,
          COALESCE(NEW.active,TRUE),
          NEW.voice,
          NEW.alternate,
          NEW.fax,
          NEW.email,
          NEW.web,
          NEW.notes,
          NEW.job_title,
          NEW.contact_change
          );

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.contact DO INSTEAD

SELECT saveCntct(
          getCntctId(NEW.contact_number),
          NEW.contact_number,
          getCrmAcctid(NEW.crm_account),
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
          NEW.honorific,
          NEW.first,
          NEW.middle,
          NEW.last,
          NEW.suffix,
          NEW.initials,
          NEW.active,
          NEW.voice,
          NEW.alternate,
          NEW.fax,
          NEW.email,
          NEW.web,
          NEW.notes,
          NEW.job_title,
          NEW.contact_change
          );

CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.contact DO INSTEAD

DELETE FROM cntct WHERE (cntct_number=OLD.contact_number);
