prompt tr_num_chk_snd_info
whenever sqlerror exit failure rollback
set echo off
set feedback off
alter session set nls_date_format = 'YYYY/MM/DD HH24:MI:SS';
set tab off
set feedback on
column table_name format A19
column SHOW_ID format A12
column SHOW_SCHEDULE_ID format 99999999999999999

column SHOW_NUMBER format 999
set echo on
set linesize 150
select
  upper('tr_num_chk_snd_info') table_name,
  SHOW_ID,
  SHOW_SCHEDULE_ID,
  SHOW_DATE,
  SHOW_NUMBER,
  del_date
from
  tr_num_chk_snd_info
order by
  SHOW_ID,
  SHOW_SCHEDULE_ID,
  SHOW_DATE,
  SHOW_NUMBER
;
exit 0
