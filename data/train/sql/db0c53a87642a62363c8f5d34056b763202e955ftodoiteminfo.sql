select xt.create_view('xt.todoiteminfo', $$

   select todoitem.*, coalesce(incdtpriority_order, 99999) as priority_order,
     crmacct_number, cntct_number, incdt_number::text, ophead_number,
     case
      when todoitem.todoitem_status = 'P' OR todoitem.todoitem_status = 'D' then todoitem.todoitem_status
      else 'N'
     end as status_proxy
   from todoitem
     left join incdtpriority on todoitem_priority_id=incdtpriority_id
     left join crmacct on crmacct_id = todoitem_crmacct_id
     left join cntct on cntct_id = todoitem_cntct_id
     left join incdt on incdt_id = todoitem_incdt_id
     left join ophead on ophead_id = todoitem_ophead_id;

$$,false);

create or replace rule "_INSERT" as on insert to xt.todoiteminfo do instead

insert into todoitem (
  todoitem_id,
  todoitem_name,
  todoitem_description,
  todoitem_incdt_id,
  todoitem_status,
  todoitem_active,
  todoitem_start_date,
  todoitem_due_date,
  todoitem_assigned_date,
  todoitem_completed_date,
  todoitem_notes,
  todoitem_crmacct_id,
  todoitem_ophead_id,
  todoitem_owner_username,
  todoitem_priority_id,
  todoitem_username,
  todoitem_recurring_todoitem_id,
  todoitem_cntct_id,
  obj_uuid
) values (
  new.todoitem_id,
  new.todoitem_name,
  new.todoitem_description,
  new.todoitem_incdt_id,
  new.todoitem_status,
  new.todoitem_active,
  new.todoitem_start_date,
  new.todoitem_due_date,
  new.todoitem_assigned_date,
  new.todoitem_completed_date,
  new.todoitem_notes,
  new.todoitem_crmacct_id,
  new.todoitem_ophead_id,
  new.todoitem_owner_username,
  new.todoitem_priority_id,
  coalesce(new.todoitem_username, geteffectivextuser()),
  new.todoitem_recurring_todoitem_id,
  new.todoitem_cntct_id,
  new.obj_uuid
);

create or replace rule "_UPDATE" as on update to xt.todoiteminfo do instead

update todoitem set
  todoitem_id=new.todoitem_id,
  todoitem_name=new.todoitem_name,
  todoitem_description=new.todoitem_description,
  todoitem_incdt_id=new.todoitem_incdt_id,
  todoitem_status=new.todoitem_status,
  todoitem_active=new.todoitem_active,
  todoitem_start_date=new.todoitem_start_date,
  todoitem_due_date=new.todoitem_due_date,
  todoitem_assigned_date=new.todoitem_assigned_date,
  todoitem_completed_date=new.todoitem_completed_date,
  todoitem_notes=new.todoitem_notes,
  todoitem_crmacct_id=new.todoitem_crmacct_id,
  todoitem_ophead_id=new.todoitem_ophead_id,
  todoitem_owner_username=new.todoitem_owner_username,
  todoitem_priority_id=new.todoitem_priority_id,
  todoitem_username=new.todoitem_username,
  todoitem_recurring_todoitem_id=new.todoitem_recurring_todoitem_id,
  todoitem_cntct_id=new.todoitem_cntct_id
where todoitem_id = old.todoitem_id;

create or replace rule "_DELETE" as on delete to xt.todoiteminfo do instead

delete from todoitem where todoitem_id = old.todoitem_id;
