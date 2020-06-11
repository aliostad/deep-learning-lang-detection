prompt tr_show_fixcredit_info
whenever sqlerror exit failure rollback
set echo off
set feedback off
alter session set nls_date_format = 'YYYY/MM/DD HH24:MI:SS';
set tab off
set feedback on
column table_name format A22
column SHOW_ID format A12
column SHOW_SCHEDULE_ID format 99999999999999999
column FIXCARDNUMP_NO format 9999
column RANGE_ID format 99999999999999999
set echo on
set linesize 150
select
  upper('tr_show_fixcredit_info') table_name,
  SHOW_ID,
  SHOW_SCHEDULE_ID,
  FIXCARDNUMP_NO,
  RANGE_ID,
  del_date
from
  tr_show_fixcredit_info
order by
  SHOW_ID,
  SHOW_SCHEDULE_ID,
  FIXCARDNUMP_NO,
  RANGE_ID
;
exit 0
