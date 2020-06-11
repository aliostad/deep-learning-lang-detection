-- Task
SELECT dropIfExists('VIEW', 'task', 'api');
CREATE VIEW api.task
AS
   SELECT 
     prj_number AS project_number,
     prjtask_number AS number,
     CASE 
       WHEN (prjtask_status = 'P') THEN
         'Concept'
       WHEN (prjtask_status = 'O') THEN
         'In-Process'
       WHEN (prjtask_status = 'C') THEN
         'Closed'
       ELSE
         'Error'
     END AS status,
     prjtask_name AS name,
     prjtask_descrip AS description,
     prjtask_owner_username AS owner,
     prjtask_username AS assigned_to,
     prjtask_hours_budget AS hours_budgeted,
     prjtask_hours_actual AS hours_actual,
     prjtask_exp_budget AS expenses_budgeted,
     prjtask_exp_actual AS expenses_actual,
     prjtask_due_date AS due,
     prjtask_assigned_date AS assigned,
     prjtask_start_date AS started,
     prjtask_completed_date AS completed
   FROM prjtask
    JOIN prj ON (prj_id=prjtask_prj_id);

GRANT ALL ON TABLE api.task TO xtrole;
COMMENT ON VIEW api.task IS 'Task';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.task DO INSTEAD

  INSERT INTO prjtask (
    prjtask_prj_id,
    prjtask_number,
    prjtask_name,
    prjtask_descrip,
    prjtask_owner_username,
    prjtask_username,
    prjtask_hours_budget,
    prjtask_hours_actual,
    prjtask_exp_budget,
    prjtask_exp_actual,
    prjtask_status,
    prjtask_due_date,
    prjtask_assigned_date,
    prjtask_start_date,
    prjtask_completed_date
    )
  VALUES (
    getPrjId(NEW.project_number),
    NEW.number,
    COALESCE(NEW.name,''),
    COALESCE(NEW.description,''),
    COALESCE(NEW.owner,getEffectiveXtUser()),
    COALESCE(NEW.assigned_to,getEffectiveXtUser()),
    COALESCE(NEW.hours_budgeted,0),
    COALESCE(NEW.hours_actual,0),
    COALESCE(NEW.expenses_budgeted,0),
    COALESCE(NEW.expenses_actual,0),
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
    ON UPDATE TO api.task DO INSTEAD

  UPDATE prjtask SET
    prjtask_name=NEW.name,
    prjtask_descrip=NEW.description,
    prjtask_owner_username=NEW.owner,
    prjtask_username=NEW.assigned_to,
    prjtask_hours_budget=NEW.hours_budgeted,
    prjtask_hours_actual=NEW.hours_actual,
    prjtask_exp_budget=NEW.expenses_budgeted,
    prjtask_exp_actual=NEW.expenses_actual,
    prjtask_status=
    CASE 
      WHEN (NEW.status='In-Process') THEN
        'O'
      WHEN (NEW.status='Completed') THEN
        'C'
      ELSE
        'P'
    END,
    prjtask_due_date=NEW.due,
    prjtask_assigned_date=NEW.assigned,
    prjtask_start_date=NEW.started,
    prjtask_completed_date=NEW.completed
  WHERE ((prjtask_prj_id=getPrjId(OLD.project_number))
   AND (prjtask_number=OLD.number));
           
CREATE OR REPLACE RULE "_DELETE" AS 
    ON DELETE TO api.task DO INSTEAD

  DELETE FROM prjtask
  WHERE ((prjtask_prj_id=getPrjId(OLD.project_number))
   AND (prjtask_number=OLD.number));
