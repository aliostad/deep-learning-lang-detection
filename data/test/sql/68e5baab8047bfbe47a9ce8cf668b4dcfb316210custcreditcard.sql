-- Customer Credit Card

SELECT dropIfExists('VIEW', 'custcreditcard', 'api');
CREATE VIEW api.custcreditcard
AS 
   SELECT 
     cust_number::varchar AS customer_number,
     CASE
       WHEN ccard_type = 'V' THEN
         'Visa'
       WHEN ccard_type = 'M' THEN
         'Master Card'
       WHEN ccard_type = 'A' THEN
         'American Express'
       WHEN ccard_type = 'D' THEN
         'Discover'
       ELSE
         'Not Supported'
     END AS credit_card_type,
     ccard_active AS active,
     ccard_number AS credit_card_number,
     ccard_name AS name, 
     ccard_address1 AS street_address1,
     ccard_address2 AS street_address2,
     ccard_city AS city, 
     ccard_state AS state, 
     ccard_zip AS postal_code,
     ccard_country AS country, 
     ccard_month_expired AS expiration_month, 
     ccard_year_expired AS expiration_year,
     (''::text) AS key
   FROM ccard, custinfo
   WHERE (ccard_cust_id=cust_id);

GRANT ALL ON TABLE api.custcreditcard TO xtrole;
COMMENT ON VIEW api.custcreditcard IS 'Customer Credit Cards.';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.custcreditcard DO INSTEAD

SELECT insertccard(
   NEW.customer_number,
   NEW.active,
   NEW.credit_card_type,
   NEW.credit_card_number,
   NEW.name,
   NEW.street_address1,
   NEW.street_address2,
   NEW.city,
   NEW.state,
   NEW.postal_code,
   NEW.country,
   NEW.expiration_month,
   NEW.expiration_year,
   NEW.key);
 

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.custcreditcard DO INSTEAD NOTHING;

CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.custcreditcard DO INSTEAD NOTHING;
