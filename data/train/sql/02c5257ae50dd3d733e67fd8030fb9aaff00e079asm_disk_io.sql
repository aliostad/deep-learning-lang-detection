
COL group_number        FORMAT 9999     HEADING 'ASM|Disk|Grp#' 
COL group_name          FORMAT A08      HEADING 'Disk|Group|Name' 
COL disk_number         FORMAT 9999     HEADING 'ASM|Disk|#'
COL total_mb            FORMAT 999999   HEADING 'Total|Disk|Space|(MB)'
COL free_mb             FORMAT 999999   HEADING 'Free|Disk|Space|(MB)'
COL mount_date          FORMAT A11      HEADING 'Mounted On' WRAP
COL repair_timer        FORMAT 99999999 HEADING 'Repair|Timer'
COL reads               FORMAT 99999999 HEADING 'Disk|Reads'
COL read_time           FORMAT 999999   HEADING 'Read|Time'
COL read_errs           FORMAT 999999   HEADING 'Read|Errors'
COL mb_read             FORMAT 999999 HEADING 'Bytes|Read|(MB)'
COL writes              FORMAT 99999999 HEADING 'Disk|Writes'
COL write_errs          FORMAT 999999   HEADING 'Write|Errors'
COL write_time          FORMAT 999999   HEADING 'Write|Time'
COL mb_wrtn             FORMAT 999999 HEADING 'Bytes|Written|(MB)'
SELECT
     ADG.name group_name
    ,AD.disk_number
    ,AD.total_mb
    ,AD.free_mb
    ,AD.repair_timer
    ,AD.reads
    ,AD.read_errs
    ,AD.read_time
    ,(AD.bytes_read / (1024*1024)) mb_read
    ,AD.writes
    ,AD.write_errs
    ,AD.write_time
    ,(AD.bytes_written / (1024*1024)) mb_wrtn
  FROM 
     v$asm_disk_stat AD
    ,v$asm_diskgroup ADG
 WHERE AD.group_number = ADG.group_number
 ORDER BY ADG.name, AD.disk_number
;
-----
-- View:    V$ASM_DISK_IOSTAT
-- Purpose: Describes additional I/O statistics for any ASM disk that's currently
--          mounted within an ASM disk group by the ASM instance
-----
COL instname          	FORMAT A08      HEADING 'Inst|Name' 
COL dbname				FORMAT A08		HEADING 'DB Name'
COL group_name          FORMAT A08      HEADING 'Disk|Group|Name' 
COL disk_number         FORMAT 9999     HEADING 'ASM|Disk|#'
COL reads               FORMAT 99999999 HEADING 'Disk|Reads'
COL read_time           FORMAT 999999   HEADING 'Read|Time|(s)'
COL read_errs           FORMAT 999999   HEADING 'Read|Errors'
COL mb_read             FORMAT 9999999 HEADING 'Bytes|Read|(MB)'
COL writes              FORMAT 99999999 HEADING 'Disk|Writes'
COL write_errs          FORMAT 999999   HEADING 'Write|Errors'
COL write_time          FORMAT 999999   HEADING 'Write|Time|(s)'
COL mb_wrtn             FORMAT 9999999 HEADING 'Bytes|Written|(MB)'

SELECT 
     IO.dbname
    ,IO.instname
    ,ADG.name group_name
    ,IO.disk_number
    ,IO.reads
    ,IO.read_errs
    ,IO.read_time
    ,(IO.bytes_read / (1024*1024)) mb_read
    ,IO.writes
    ,IO.write_errs
    ,IO.write_time
    ,(IO.bytes_written / (1024*1024)) mb_wrtn	
	-- New in 11gR2 
    ,IO.hot_reads
    ,IO.cold_reads
    ,(IO.hot_bytes_read / (1024*1024)) hot_mb_read
    ,(IO.cold_bytes_read / (1024*1024)) cold_mb_read
    ,IO.hot_writes
    ,IO.cold_writes
    ,(IO.hot_bytes_written / (1024*1024)) hot_mb_wrtn
    ,(IO.cold_bytes_written / (1024*1024)) cold_mb_wrtn
  FROM 
     v$asm_disk_iostat IO
    ,v$asm_diskgroup ADG
 WHERE IO.group_number = ADG.group_number
 ORDER BY IO.dbname, IO.instname, ADG.name
;
