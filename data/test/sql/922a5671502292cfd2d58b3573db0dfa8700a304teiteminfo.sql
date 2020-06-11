select xt.create_view('xt.teiteminfo', $$

select teitem.*,
  teitem_qty * teitem_empcost as hourly_total,
  basecurrid() as hourly_curr_id
from te.teitem;

$$, false);


create or replace rule "_INSERT" as on insert to xt.teiteminfo do instead

insert into te.teitem (
  teitem_id,
  teitem_tehead_id,
  teitem_linenumber,
  teitem_type,
  teitem_workdate,
  teitem_cust_id,
  teitem_vend_id,
  teitem_po,
  teitem_item_id,
  teitem_qty,
  teitem_rate,
  teitem_total,
  teitem_prjtask_id,
  teitem_lastupdated,
  teitem_billable,
  teitem_prepaid,
  teitem_notes,
  teitem_posted,
  teitem_curr_id,
  teitem_uom_id,
  teitem_invcitem_id,
  teitem_vodist_id,
  teitem_postedvalue,
  teitem_empcost,
  obj_uuid
) values (
  coalesce(new.teitem_id, nextval('te.timesheet_seq'::regclass)),
  new.teitem_tehead_id,
  new.teitem_linenumber,
  new.teitem_type,
  new.teitem_workdate,
  new.teitem_cust_id,
  new.teitem_vend_id,
  new.teitem_po,
  new.teitem_item_id,
  new.teitem_qty,
  new.teitem_rate,
  new.teitem_total,
  new.teitem_prjtask_id,
  coalesce(new.teitem_lastupdated, ('now'::text)::timestamp(6) with time zone),
  new.teitem_billable,
  new.teitem_prepaid,
  new.teitem_notes,
  coalesce(new.teitem_posted, false),
  new.teitem_curr_id,
  new.teitem_uom_id,
  new.teitem_invcitem_id,
  new.teitem_vodist_id,
  coalesce(new.teitem_postedvalue, 0),
  new.teitem_empcost,
  new.obj_uuid
);

create or replace rule "_UPDATE" as on update to xt.teiteminfo do instead

update te.teitem set
  teitem_linenumber=new.teitem_linenumber,
  teitem_workdate=new.teitem_workdate,
  teitem_cust_id=new.teitem_cust_id,
  teitem_vend_id=new.teitem_vend_id,
  teitem_po=new.teitem_po,
  teitem_item_id=new.teitem_item_id,
  teitem_qty=new.teitem_qty,
  teitem_rate=new.teitem_rate,
  teitem_total=new.teitem_total,
  teitem_prjtask_id=new.teitem_prjtask_id,
  teitem_lastupdated=new.teitem_lastupdated,
  teitem_billable=new.teitem_billable,
  teitem_prepaid=new.teitem_prepaid,
  teitem_notes=new.teitem_notes,
  teitem_posted=new.teitem_posted,
  teitem_curr_id=new.teitem_curr_id,
  teitem_uom_id=new.teitem_uom_id,
  teitem_invcitem_id=new.teitem_invcitem_id,
  teitem_vodist_id=new.teitem_vodist_id,
  teitem_postedvalue=new.teitem_postedvalue,
  teitem_empcost=new.teitem_empcost
where teitem_id = old.teitem_id;

create or replace rule "_DELETE" as on delete to xt.teiteminfo do instead

delete from te.teitem where teitem_id=old.teitem_id;