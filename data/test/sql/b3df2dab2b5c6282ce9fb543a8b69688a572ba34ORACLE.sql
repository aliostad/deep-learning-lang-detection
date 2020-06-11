drop table SA_USERS purge; 
-- Create table
create table SA_USERS
(
  staff_id   NUMBER,
  staff_name VARCHAR2(64),
  passwd varchar2(32),
  org_id     NUMBER,
  staff_type NUMBER,
  create_time date
);

-- Add comments to the columns 
comment on column SA_USERS.staff_type
  is '1:普通员工,2:经理';

select * from SA_USERS for update;

commit;

/*
属性版本编码
属性名称
数据周期
分析框架编码
分析框架名称
属性分类编码
属性分类名称
绑定维层编码
绑定维层名称
业务描述
敏感等级
加密策略
物理表编码
物理表中文名称
物理表名称
物理表字段
*/
create table sa_users
(
  staff_id    NUMBER,
  staff_name  VARCHAR2(64),
  passwd      varchar2(32),
  org_id      NUMBER,
  staff_type  NUMBER,
  create_time date
);


/*
create table sa_cfg_frame_detail as
select * from pt166.sa_cfg_frame_detail where 1 = 0;

truncate table sa_cfg_frame_detail;
*/

select * from sa_cfg_frame_detail;

select tname, cname from sa_cfg_frame_detail group by tname, cname having count(0) > 1;
 
create table sa_cfg_frame
(
  frame_id varchar2(64),
  frame_name varchar2(64),
  frame_desc varchar2(4000)
);

create table sa_cfg_attr_class (
  frame_id varchar2(64),
  attr_class_id varchar2(64),
  attr_class_name varchar2(256),
  attr_class_desc varchar2(4000)
);

create table sa_cfg_attr (
  attr_class_id varchar2(64),
  attr_id varchar2(64),
  attr_name varchar2(64),
  attr_desc varchar2(4000),
  dim_id  varchar2(64),
  sensitive_type  number,--敏感等级
  encrypt_type  number --加密类型
);

create table sa_cfg_dim (
  dim_id varchar2(64),
  dim_name varchar2(64),
  dim_sql varchar2(4000)
);

/*
drop table sa_cfg_table purge; 
*/
create table sa_cfg_table
(
  table_id     varchar2(64),
  table_name     varchar2(64),
  table_name_cn  varchar2(64),
  table_desc     varchar2(4000),
	update_date    number,
  cycle_type  number(1) --1,按日;2,按月
);

drop table sa_cfg_column purge; 
create table sa_cfg_column
(
  table_name varchar2(64),
  column_name varchar2(64),
  column_name_cn varchar2(64),
  column_type number,  --1,数值类型;2,字符串;3,时间;4,BLOB
  column_desc varchar2(4000)
);

create table sa_cfg_attr_column_rela (
  attr_id varchar2(64),
  column_id varchar2(64)
);


/*
truncate table sa_cfg_frame;
*/
insert /*+APPEND NOLOGGING*/
into sa_cfg_frame
  (frame_id, frame_name)
  select distinct fcode, fname from sa_cfg_frame_detail ;
commit;

select * from sa_cfg_frame;
/*
truncate table sa_cfg_attr_class;
*/
insert /*+APPEND NOLOGGING*/
into sa_cfg_attr_class
  (frame_id, attr_class_id, attr_class_name)
  select distinct fcode, vcode, vname from sa_cfg_frame_detail;
commit;

select *
  from sa_cfg_attr_class
 where attr_class_id = 'V00000000450'
   for update;
commit;

select * from sa_cfg_attr_class;

select * from sa_cfg_attr;

select count(0) from sa_cfg_frame_detail;

commit;

select * from sa_cfg_attr;
/*
truncate table sa_cfg_attr;
*/
insert /*+APPEND NOLOGGING*/
into sa_cfg_attr
  (attr_class_id,
   attr_id,
   attr_name,
   attr_desc,
   dim_id,
   sensitive_type,
   encrypt_type)
  select distinct vcode,
                  scode,
                  sname,
									busi_desc,
                  lcode,
                  decode(seni_level, '工作秘密级', 1, '机密级', 2, '秘密级', 3),
                  decode(encode_type, '完全开放', 1, '不开放', 2, '掩码加密', 3)
    from sa_cfg_frame_detail;
commit;

select * from sa_cfg_attr;

select attr_id from sa_cfg_attr group by attr_id having count(0) > 1;

select * from sa_cfg_frame_detail;
/*
truncate table sa_cfg_table;
*/
insert /*+APPEND NOLOGGING*/
into sa_cfg_table
  (table_id,
   table_name,
   table_name_cn,
   /*TABLE_DESC,*/
   cycle_type)
  select distinct tcode, tname, tname_cn, decode(cycle_type, '日', 1, '月', 2, 99)
    from sa_cfg_frame_detail;
commit;

select * from sa_cfg_table;

select table_name from sa_cfg_table group by table_name having count(0) > 1;

insert /*+APPEND NOLOGGING*/ into sa_cfg_column ()
;

