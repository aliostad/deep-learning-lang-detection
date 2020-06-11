DO $$
  /* The only purpose of this view is to cast the number as a string because we can't touch the schema directly */
  var dropSql = "drop view if exists xt.incdtxt cascade;";
  var sql = "create or replace view xt.incdtxt as " +
   "select incdt_id, incdt_number::text, incdt_crmacct_id, incdt_cntct_id, incdt_summary, " +
   "incdt_descrip, incdt_item_id, incdt_timestamp, incdt_status, incdt_assigned_username, " +
   "incdt_incdtcat_id, incdt_incdtseverity_id, incdt_incdtpriority_id, incdt_incdtresolution_id, " +
   "incdt_lotserial, incdt_ls_id, incdt_aropen_id, incdt_owner_username, " +
   "incdt_recurring_incdt_id, incdt_updated, " +
   "incdt_prj_id, incdt_public, obj_uuid " +
   "from incdt ";

  try {
    plv8.execute(sql);
  } catch (error) {
    /* let's cascade-drop the view and try again */
    plv8.execute(dropSql);
    plv8.execute(sql);
  }

$$ language plv8;

revoke all on xt.incdtxt from public;
grant all on table xt.incdtxt to group xtrole;

create or replace rule "_INSERT" as on insert to xt.incdtxt do instead

insert into incdt (
  incdt_id,
  incdt_number,
  incdt_crmacct_id,
  incdt_cntct_id,
  incdt_summary,
  incdt_descrip,
  incdt_item_id,
  incdt_timestamp,
  incdt_status,
  incdt_assigned_username,
  incdt_incdtcat_id,
  incdt_incdtseverity_id,
  incdt_incdtpriority_id,
  incdt_incdtresolution_id,
  incdt_ls_id,
  incdt_aropen_id,
  incdt_owner_username,
  incdt_recurring_incdt_id,
  incdt_updated,
  incdt_prj_id,
  incdt_public,
  obj_uuid
) values (
  new.incdt_id,
  new.incdt_number::integer,
  new.incdt_crmacct_id,
  new.incdt_cntct_id,
  new.incdt_summary,
  new.incdt_descrip,
  new.incdt_item_id,
  coalesce(new.incdt_timestamp, now()),
  coalesce(new.incdt_status, 'N'),
  new.incdt_assigned_username,
  new.incdt_incdtcat_id,
  new.incdt_incdtseverity_id,
  new.incdt_incdtpriority_id,
  new.incdt_incdtresolution_id,
  new.incdt_ls_id,
  new.incdt_aropen_id,
  new.incdt_owner_username,
  new.incdt_recurring_incdt_id,
  coalesce(new.incdt_updated, now()),
  new.incdt_prj_id,
  new.incdt_public,
  coalesce(new.obj_uuid, xt.uuid_generate_v4())
);

create or replace rule "_UPDATE" as on update to xt.incdtxt do instead

update incdt set
  incdt_number = new.incdt_number::integer,
  incdt_crmacct_id = new.incdt_crmacct_id,
  incdt_cntct_id = new.incdt_cntct_id,
  incdt_summary = new.incdt_summary,
  incdt_descrip  = new.incdt_descrip,
  incdt_item_id = new.incdt_item_id,
  incdt_timestamp = new.incdt_timestamp,
  incdt_status = new.incdt_status,
  incdt_assigned_username = new.incdt_assigned_username,
  incdt_incdtcat_id = new.incdt_incdtcat_id,
  incdt_incdtseverity_id = new.incdt_incdtseverity_id,
  incdt_incdtpriority_id = new.incdt_incdtpriority_id,
  incdt_incdtresolution_id = new.incdt_incdtresolution_id,
  incdt_ls_id = new.incdt_ls_id,
  incdt_aropen_id = new.incdt_aropen_id,
  incdt_owner_username = new.incdt_owner_username,
  incdt_recurring_incdt_id = new.incdt_recurring_incdt_id,
  incdt_updated = new. incdt_updated,
  incdt_prj_id = new. incdt_prj_id,
  incdt_public = new. incdt_public,
  obj_uuid = new. obj_uuid
where incdt_id = old.incdt_id;

create or replace rule "_DELETE" as on delete to xt.incdtxt
  do instead nothing;
