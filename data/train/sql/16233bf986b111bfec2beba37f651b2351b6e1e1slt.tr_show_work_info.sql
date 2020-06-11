prompt tr_show_work_info
whenever sqlerror exit failure rollback
alter session set nls_date_format = 'YYYY/MM/DD HH24:MI:SS';
set tab off
set null <NULL>
set feedback on
column SHOW_ID format A12
column SHOW_TYPE format A2
column SHOW_NAME format A160
column SHOW_NAME2 format A40
column SHOW_KANA format A120
column SHOW_AREA_ID format 99
column PREFECTURE_ID format 999
column SHOW_COMMENT format A200
column OPEN_DATE format A19
column CLOSE_DATE format A19
column TERM_COMMENT format A120
column ARTIST_NAME format A160
column ARTIST_KANA format A60
column DATA_FLAG format 99
set echo on
desc tr_show_work_info
set linesize 878
select
  SHOW_ID,
  SHOW_TYPE,
  SHOW_NAME,
  SHOW_NAME2,
  SHOW_KANA,
  SHOW_AREA_ID,
  PREFECTURE_ID,
  SHOW_COMMENT,
  OPEN_DATE,
  CLOSE_DATE,
  TERM_COMMENT,
  ARTIST_NAME,
  ARTIST_KANA,
  DATA_FLAG
from
  tr_show_work_info
order by
  SHOW_ID
;
exit 0
