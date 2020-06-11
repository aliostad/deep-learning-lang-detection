set trimspool on
set feedback off
set pagesize 0
set linesize 1000
set long 100000
column view_text format a1000
set serverout on
set verify off
set trimspool on
column in_view_lc new_value view_filename
select lower('&2')||'.sql' in_view_lc from dual;
spool &view_filename
select 'create or replace view '||v.owner||'.'||v.view_name
  from all_views v
 where v.view_name = upper('&2')
   and v.owner = upper('&1');

select text view_text
  from all_views v
 where v.view_name = upper('&2')
   and v.owner = upper('&1');
prompt /
spool off

set feedback on
set pagesize 40
set linesize 132
set verify on

