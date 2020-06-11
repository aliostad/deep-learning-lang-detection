drop table CFG_SUPP_STAFF_INFO purge; 
-- Create table
create table CFG_SUPP_STAFF_INFO
(
  staff_id   NUMBER,
  staff_name VARCHAR2(64),
  passwd varchar2(32),
  org_id     NUMBER,
  staff_type NUMBER,
  create_time date
)
tablespace GETDB
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 80K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column CFG_SUPP_STAFF_INFO.staff_type
  is '1:普通员工,2:室经理';

insert /*+ append nologging */ into cfg_supp_staff_info 
select * from pt166.cfg_supp_staff_info;
commit;
 
  

select * from cfg_supp_staff_info for update;

commit;

select * from getdb.sms_organization where org_id = 4009990;

create table cfg_supp_staff_bonus (
  sum_month number(6),
  judge_id number,
  staff_id number,
  judge_time number,
  wld_score number,
  dfc_score number,
  qua_score number
);

select * from cfg_supp_staff_bonus;
