 
select zsse_DropView ('tsrv_feedback_v');
create or replace view tsrv_feedback_v as
select
 zspm_ptaskfeedbackline_id AS tsrv_feedback_v_id,
 ad_client_id,
 ad_org_id,
 isactive,
 created,
 createdby,
 updated,
 updatedby,
 c_project_id,
 c_projecttask_id,
 c_calendarevent_id,
 ad_user_id as employee_id,
 ma_machine_id,
 description,
 workdate,
 hour_from,
 hour_to,
 actualcostamount,
 c_salary_category_id,
 hours,
 breaktime,
 traveltime,
 specialtime as timeunderhelmet,
 specialtime2 as timeunderhelmet2,
 triggeramt as triggeramt,
 overtimehours,nighthours,issaturday,issunday,isholiday
 from zspm_ptaskfeedbackline;
 
create or replace rule tsrv_feedback_delete as
on delete to tsrv_feedback_v do instead
delete from zspm_ptaskfeedbackline where
       zspm_ptaskfeedbackline_id = old.tsrv_feedback_v_id;
       
create or replace rule tsrv_feedback_insert as
on insert to tsrv_feedback_v do instead 
    insert into zspm_ptaskfeedbackline(zspm_ptaskfeedbackline_id, ad_client_id, ad_org_id, isactive, created, createdby, updated, updatedby, c_project_id, c_projecttask_id, c_calendarevent_id, ad_user_id, ma_machine_id,
                description, workdate, hour_from, hour_to, c_salary_category_id, hours, breaktime, traveltime, specialtime, specialtime2, triggeramt) 
    values
            (new.tsrv_feedback_v_id,new.ad_client_id, new.ad_org_id, new.isactive, new.created, new.createdby, new.updated, new.updatedby, new.c_project_id, new.c_projecttask_id, new.c_calendarevent_id, new.employee_id, new.ma_machine_id,
             new.description, new.workdate, new.hour_from, new.hour_to, new.c_salary_category_id, new.hours, new.breaktime, new.traveltime,new.timeunderhelmet,new.timeunderhelmet2,new.triggeramt);

             
create or replace rule tsrv_feedback_update as
on update to tsrv_feedback_v do instead 
      update zspm_ptaskfeedbackline set
        ad_org_id=new.ad_org_id,
        isactive=new.isactive,
        updated=new.updated,
        updatedby=new.updatedby,
        c_project_id=new.c_project_id,
        c_projecttask_id=new.c_projecttask_id,
        c_calendarevent_id=new.c_calendarevent_id,
        ad_user_id=new.employee_id,
        ma_machine_id=new.ma_machine_id,
        description=new.description,
        workdate=new.workdate,
        hour_from=new.hour_from,
        hour_to=new.hour_to,
        c_salary_category_id=new.c_salary_category_id,
        hours=new.hours,
        breaktime=new.breaktime,
        traveltime=new.traveltime,
        specialtime =new.timeunderhelmet,
        specialtime2 =new.timeunderhelmet2,
        triggeramt = new.triggeramt
where zspm_ptaskfeedbackline_id=new.tsrv_feedback_v_id;