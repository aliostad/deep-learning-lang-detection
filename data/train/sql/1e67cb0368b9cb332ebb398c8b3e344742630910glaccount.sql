--GL Account View

SELECT dropIfExists('VIEW', 'glaccount', 'api');
CREATE OR REPLACE VIEW api.glaccount AS
 
SELECT 
  accnt_company::varchar AS company,
  accnt_profit::varchar AS profit_center,
  accnt_number::varchar AS account_number,
  accnt_sub::varchar AS sub_account,
  accnt_descrip AS description,
  accnt_extref AS ext_reference,
  CASE
    WHEN accnt_type='A' THEN 'Asset'
    WHEN accnt_type='L' THEN 'Liability'
    WHEN accnt_type='E' THEN 'Expense'
    WHEN accnt_type='R' THEN 'Revenue'
    WHEN accnt_type='Q' THEN 'Equity'
    ELSE '?'
  END AS type,
  accnt_subaccnttype_code AS sub_type,
  accnt_forwardupdate AS forward_update_trial_balances,
  accnt_comments AS notes
FROM
  accnt
ORDER BY accnt_company, accnt_profit, accnt_number, accnt_sub;

GRANT ALL ON TABLE api.glaccount TO xtrole;
COMMENT ON VIEW api.glaccount IS 'GL Account';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.glaccount DO INSTEAD

INSERT INTO accnt (
  accnt_number,
  accnt_descrip,
  accnt_comments,
  accnt_profit,
  accnt_sub,
  accnt_type,
  accnt_extref,
  accnt_company,
  accnt_forwardupdate,
  accnt_subaccnttype_code )
VALUES (
  COALESCE(NEW.account_number, ''),
  COALESCE(NEW.description, ''),
  COALESCE(NEW.notes, ''),
  NEW.profit_center,
  NEW.sub_account,
  CASE
    WHEN NEW.type='Asset' THEN 'A'
    WHEN NEW.type='Liability' THEN 'L'
    WHEN NEW.type='Expense' THEN 'E'
    WHEN NEW.type='Revenue' THEN 'R'
    WHEN NEW.type='Equity' THEN 'Q'
    ELSE NULL
  END,
  COALESCE(NEW.ext_reference, ''),
  NEW.company,
  COALESCE(NEW.forward_update_trial_balances, false),
  COALESCE(NEW.sub_type, '') );

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.glaccount DO INSTEAD

UPDATE accnt SET
  accnt_number=NEW.account_number,
  accnt_descrip=NEW.description,
  accnt_comments=NEW.notes,
  accnt_profit=NEW.profit_center,
  accnt_sub=NEW.sub_account,
  accnt_type=CASE
               WHEN NEW.type='Asset' THEN 'A'
               WHEN NEW.type='Liability' THEN 'L'
               WHEN NEW.type='Expense' THEN 'E'
               WHEN NEW.type='Revenue' THEN 'R'
               WHEN NEW.type='Equity' THEN 'Q'
               ELSE NULL
             END,
  accnt_extref=NEW.ext_reference,
  accnt_company=NEW.company,
  accnt_forwardupdate=NEW.forward_update_trial_balances,
  accnt_subaccnttype_code=NEW.sub_type
WHERE accnt.accnt_id = getglaccntid(old.company::text,old.profit_center::text,old.account_number::text,old.sub_account::text);
