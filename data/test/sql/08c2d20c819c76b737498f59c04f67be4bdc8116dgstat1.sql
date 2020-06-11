
-- Thorsten Bruhns (Thorsten.Bruhns@opitz-consulting.de)
-- The origin of this sql is unknown
--
-- Get statistical data for a given Diskgroup
-- Parameter 1: Diskgroup-Name
--
-- Version  Date        Description
-- 0.1      16.01.2014  Initial Version


col disk_path format a16 heading "Disk Path"
col total_mb format 999,999 heading "MB"
col avg_read_ms format 999.99 heading "Avg Read|(ms)"
col io_1k format  999,999 heading "IO|/1000"
col io_secs format  999,999 heading "IO|seconds"
col pct_io format 999.99 heading "Pct|IO"
col pct_time format 999.99 heading "Pct|Time"
set pagesize 10000
set lines 75
set verify off 
set echo on 

SELECT d.PATH disk_path, d.total_mb,
       ROUND(ds.read_secs * 1000 / ds.reads, 2) avg_read_ms, 
       ds.reads/1000 +  ds.writes/1000 io_1k, 
       ds.read_secs +ds.write_secs io_secs,
       ROUND((d.reads + d.writes) * 100 / 
            SUM(d.reads + d.writes) OVER (),2) pct_io,
       ROUND((ds.read_secs +ds.write_secs)*100/
            SUM(ds.read_secs +ds.write_secs) OVER (),2) pct_time
  FROM v$asm_diskgroup_stat dg
  JOIN v$asm_disk_stat d ON (d.group_number = dg.group_number)
  JOIN (SELECT group_number, disk_number disk_number, SUM(reads) reads,
               SUM(writes) writes, ROUND(SUM(read_time), 2) read_secs,
               ROUND(SUM(write_time), 2) write_secs
          FROM gv$asm_disk_stat 
         WHERE mount_status = 'CACHED'
         GROUP BY group_number, disk_number) ds
        ON (ds.group_number = d.group_number
            AND ds.disk_number = d.disk_number)
WHERE dg.name = '&diskgroup_name' 
   AND d.mount_status = 'CACHED'
ORDER BY d.PATH;

