-- Project
SELECT dropIfExists('VIEW', 'project', 'api');
CREATE VIEW api.project
AS
   SELECT 
     prj_number AS number,
     prj_name AS name,
     prj_descrip AS description,
     prj_owner_username AS owner,
     prj_username AS assigned_to,
     prj_so AS sales_orders,
     prj_wo AS work_orders,
     prj_po AS purchase_orders,
     CASE 
       WHEN (prj_status = 'P') THEN
         'Concept'
       WHEN (prj_status = 'O') THEN
         'In-Process'
       WHEN (prj_status = 'C') THEN
         'Closed'
       ELSE
         'Error'
     END AS status,
     prj_due_date AS due,
     prj_assigned_date AS assigned,
     prj_start_date AS started,
     prj_completed_date AS completed
   FROM prj;

GRANT ALL ON TABLE api.project TO xtrole;
COMMENT ON VIEW api.project IS 'Project';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.project DO INSTEAD

  INSERT INTO prj (
    prj_number,
    prj_name,
    prj_descrip,
    prj_owner_username,
    prj_username,
    prj_so,
    prj_wo,
    prj_po,
    prj_status,
    prj_due_date,
    prj_assigned_date,
    prj_start_date,
    prj_completed_date
    )
  VALUES (
    NEW.number,
    COALESCE(NEW.name,''),
    COALESCE(NEW.description,''),
    COALESCE(NEW.owner,getEffectiveXtUser()),
    COALESCE(NEW.assigned_to,getEffectiveXtUser()),
    COALESCE(NEW.sales_orders,true),
    COALESCE(NEW.work_orders,true),
    COALESCE(NEW.purchase_orders,true),
    CASE 
      WHEN (NEW.status='In-Process') THEN
        'O'
      WHEN (NEW.status='Completed') THEN
        'C'
      ELSE
        'P'
    END,
    NEW.due,
    NEW.assigned,
    NEW.started,
    NEW.completed
    );

CREATE OR REPLACE RULE "_UPDATE" AS 
    ON UPDATE TO api.project DO INSTEAD

  UPDATE prj SET
    prj_name=NEW.name,
    prj_descrip=NEW.description,
    prj_owner_username=NEW.owner,
    prj_username=NEW.assigned_to,
    prj_so=NEW.sales_orders,
    prj_wo=NEW.work_orders,
    prj_po=NEW.purchase_orders,
    prj_status=
    CASE 
      WHEN (NEW.status='In-Process') THEN
        'O'
      WHEN (NEW.status='Completed') THEN
        'C'
      ELSE
        'P'
    END,
    prj_due_date=NEW.due,
    prj_assigned_date=NEW.assigned,
    prj_start_date=NEW.started,
    prj_completed_date=NEW.completed
  WHERE (prj_number=OLD.number);
           
CREATE OR REPLACE RULE "_DELETE" AS 
    ON DELETE TO api.project DO INSTEAD

  SELECT deleteproject (getPrjId(OLD.number));
