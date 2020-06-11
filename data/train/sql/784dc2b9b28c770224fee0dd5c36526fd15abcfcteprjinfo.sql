select xt.create_view('xt.teprjinfo', $$
  select teprj.*,
    case when teprj_curr_id is not null then true
         else false
    end as teprj_specified_rate
  from te.teprj
$$, false);

create or replace rule "_INSERT" as on insert to xt.teprjinfo do instead

insert into te.teprj (
  teprj_id,
  teprj_cust_id,
  teprj_prj_id,
  teprj_rate,
  teprj_curr_id
) values (
  coalesce(new.teprj_id, nextval('te.teprj_teprj_id_seq')),
  new.teprj_cust_id,
  new.teprj_prj_id,
  new.teprj_rate,
  new.teprj_curr_id
);

create or replace rule "_UPDATE" as on update to xt.teprjinfo do instead

update te.teprj set
  teprj_cust_id=new.teprj_cust_id,
  teprj_prj_id=new.teprj_prj_id,
  teprj_rate=new.teprj_rate,
  teprj_curr_id=new.teprj_curr_id
where teprj_id = old.teprj_id;

create or replace rule "_DELETE" as on delete to xt.teprjinfo do instead

delete from te.teprj where teprj_id = old.teprj_id;
