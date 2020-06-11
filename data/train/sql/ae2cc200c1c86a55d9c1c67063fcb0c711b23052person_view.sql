
use osso;

-- For some reason the union takes much longer than
-- Individual queries
-- Can research later
DROP   VIEW IF EXISTS person_view_reg_union;
CREATE VIEW           person_view_reg_union AS
SELECT * FROM osso.reg_main_view_all
UNION ALL
SELECT * FROM eayso.reg_main_view_all
;

DROP VIEW IF EXISTS person_view_reg;
CREATE VIEW         person_view_reg AS
SELECT
  person.id            AS id,
  person_reg.reg_type  AS reg_type,
  person_reg.reg_num   AS reg_num,

  reg_main_view_all.reg_main_fname AS fname,
  reg_main_view_all.reg_main_lname AS lname,
  reg_main_view_all.reg_main_nname AS nname,

  reg_main_view_all.reg_org_org_id AS org_id,
  reg_main_view_all.org_desc1      AS org_desc1,

  reg_main_view_all.reg_cert_cat   AS cert_cat,
  reg_main_view_all.reg_cert_type  AS cert_type,
  reg_main_view_all.reg_cert_date  AS cert_date,

  reg_main_view_all.reg_prop_type  AS prop_type,
  reg_main_view_all.reg_prop_value AS prop_value

FROM person
LEFT JOIN person_reg ON person_reg.person_id = person.id
LEFT JOIN person_view_reg_union AS reg_main_view_all ON
  reg_main_view_all.reg_main_reg_type = person_reg.reg_type AND
  reg_main_view_all.reg_main_reg_num  = person_reg.reg_num

;
