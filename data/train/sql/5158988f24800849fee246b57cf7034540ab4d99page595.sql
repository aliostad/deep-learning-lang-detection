set echo on

set termout off

drop table my_all_objects;

create table my_all_objects
nologging
as
select * from all_objects
union all
select * from all_objects
union all
select * from all_objects
/

insert /*+ APPEND */ into my_all_objects 
select * from my_all_objects;

commit;

insert /*+ APPEND */ into my_all_objects 
select * from my_all_objects;

commit;

analyze table my_all_objects compute statistics;

set autotrace on
set timing on
select owner, count(*) from my_all_objects group by owner;

set timing off
set autotrace traceonly
select owner, count(*) from my_all_objects group by owner;
set autotrace off


grant query rewrite to tkyte;

alter session set query_rewrite_enabled=true;

alter session set query_rewrite_integrity=enforced;

create materialized view my_all_objects_aggs
build immediate
refresh on commit
enable query rewrite
as
select owner, count(*)
  from my_all_objects
 group by owner
/
 
analyze table my_all_objects_aggs compute statistics;

set timing on
select owner, count(*)
  from my_all_objects
 group by owner;
set timing off

set autotrace traceonly
select owner, count(*)
  from my_all_objects
 group by owner;
set autotrace off

insert into my_all_objects 
( owner, object_name, object_type, object_id )
values
( 'New Owner', 'New Name', 'New Type', 1111111 );

commit;

set timing on
select owner, count(*)
  from my_all_objects
 where owner = 'New Owner'
 group by owner;
set timing off

set autotrace traceonly 
select owner, count(*)
  from my_all_objects
 where owner = 'New Owner'
 group by owner;
set autotrace off


set timing on
select count(*)
  from my_all_objects
 where owner = 'New Owner';
set timing off

set autotrace traceonly
select count(*)
  from my_all_objects
 where owner = 'New Owner';
set autotrace off

spool off
set termout on


set timing on
select lower(owner) from my_all_objects group by owner;
set timing off

set autotrace traceonly
select lower(owner) from my_all_objects group by owner;
set autotrace off
