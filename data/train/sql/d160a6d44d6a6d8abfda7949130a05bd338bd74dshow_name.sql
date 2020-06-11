set feedback off
whenever sqlerror exit failure rollback
alter session set nls_date_format = 'YYYY/MM/DD HH24:MI:SS';
set tab off
set null <NULL>
set heading on
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
set linesize 878
set feedback off
whenever sqlerror exit failure rollback
alter session set nls_date_format = 'YYYY/MM/DD HH24:MI:SS';
set tab off
set null <NULL>
set heading on
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
column REG_DATE format A19
column UPD_DATE format A19
column DEL_DATE format A19
set linesize 877
set feedback on
  select
    'tr_show_work_info',
    show_id
    ,show_name
  from
    tr_show_work_info where show_id = '00005'
  order by
    show_id
  ;
set feedback on
  select
    'tr_show_tkt_info',
    show_id
    ,show_name
  from
    tr_show_tkt_info where show_id = '00005'
  order by
    show_id
  ;
exit 0
