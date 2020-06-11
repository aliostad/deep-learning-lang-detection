set linesize 180
set pagesize 80
set feedback off

column file_name      format a37        heading 'File Name'
column tbs            format a13        heading 'TBS'
column read_mb        format 9,999,999  heading 'Read MB'
column write_mb       format 9,999,999  heading 'Write MB'
column reads          format 99,999,999 heading 'Reads'
column writes         format 99,999,999 heading 'Writes'
column read_time_ms   format 99,999,999 heading 'Read Tim'
column write_time_ms  format 99,999,999 heading 'Write Tim'
column rd_time_avg    format 990.999    heading 'Rd Tim Avg'
column wr_time_avg    format 990.999    heading 'Wr Tim Avg'

column lg_rds         format 99,999,999  heading 'LG Reads'
column lg_rd_mb       format 9,999,999   heading 'LG Rd MB'
column lg_rd_tm_avg   format 990.999     heading 'LG Rd Tm'
column sm_rds         format 99,999,999  heading 'SM Reads'
column sm_rd_mb       format 9,999,999   heading 'SM Rd MB'
column sm_rd_tm_avg   format 990.999     heading 'SM Rd Tm'
column lg_wrts        format 99,999,999  heading 'LG Writes'
column lg_wt_mb       format 9,999,999   heading 'LG Wr MB'
column lg_wr_tm_avg   format 990.999     heading 'LG Wr Tm'
column sm_wrts        format 99,999,999  heading 'SM Writes'
column sm_wr_mb       format 9,999,999   heading 'SM Wr MB'
column sm_wr_tm_avg   format 990.999     heading 'SM Wr Tm'

ttitle on
ttitle center '*************************  Read/Write Statistics for Database Data Files  *************************' skip 2

select  replace( df.file_name, '${ORACLE_SID}/oradata', '...' ) file_name,
        df.tablespace_name tbs,
	ios.large_read_reqs lg_rds, ios.large_read_megabytes lg_rd_mb,
	ios.small_read_reqs sm_rds, ios.small_read_megabytes sm_rd_mb,
	ios.large_write_reqs lg_wrts, ios.large_write_megabytes lg_wt_mb,
	ios.small_write_reqs sm_wrts, ios.small_write_megabytes sm_wr_mb,
	greatest( ios.large_read_servicetime, 1 ) / greatest( ios.large_read_reqs, 1 ) lg_rd_tm_avg,
	greatest( ios.small_read_servicetime, 1 ) / greatest( ios.small_read_reqs, 1 ) sm_rd_tm_avg,
	greatest( ios.large_write_servicetime, 1 ) / greatest( ios.large_write_reqs, 1 ) lg_wr_tm_avg,
	greatest( ios.small_write_servicetime, 1 ) / greatest( ios.small_write_reqs, 1 ) sm_wr_tm_avg
from    v$iostat_file ios, dba_data_files df
where   ios.filetype_name = 'Data File'
and     df.file_id = ios.file_no
order by 3 desc, tablespace_name;

prompt
prompt
ttitle center '*************************  Read/Write Statistics for Temporary Data Files  *************************' skip 2

select  df.file_name,
        df.tablespace_name tbs,
        ios.large_read_reqs lg_rds, ios.large_read_megabytes lg_rd_mb,
        ios.small_read_reqs sm_rds, ios.small_read_megabytes sm_rd_mb,
        ios.large_write_reqs lg_wrts, ios.large_write_megabytes lg_wt_mb,
        ios.small_write_reqs sm_wrts, ios.small_write_megabytes sm_wr_mb,
        greatest( ios.large_read_servicetime, 1 ) / greatest( ios.large_read_reqs, 1 ) lg_rd_tm_avg,
        greatest( ios.small_read_servicetime, 1 ) / greatest( ios.small_read_reqs, 1 ) sm_rd_tm_avg,
        greatest( ios.large_write_servicetime, 1 ) / greatest( ios.large_write_reqs, 1 ) lg_wr_tm_avg,
        greatest( ios.small_write_servicetime, 1 ) / greatest( ios.small_write_reqs, 1 ) sm_wr_tm_avg
from    v$iostat_file ios, dba_temp_files df
where   ios.filetype_name = 'Temp File'
and     df.file_id = ios.file_no
order by 3 desc, tablespace_name;
