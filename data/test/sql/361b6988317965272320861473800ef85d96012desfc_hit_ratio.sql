----------------------------------------------------------------------------------------
--
-- File name:   esfc_hit_ratio.sql
--
-- Purpose:     Calculates a psuedo hit ratio for cell flash cache on Exadata storage.
--
-- Author:      Kerry Osborne
--
-- Description: 
--
--              The script uses the total number of cell single block physical read" events 
--              plus the total number of "cell multiblock physical read" events as an 
--              approximation of the total number of reads and compares that to total number
--              of cell flash cache hits.
--
--
--        Note: This script does not produce accurate results. The calculated
--              hit ratio will be overstated. A better approach is to evaluate
--              average access times for read operations such as the
--              "cell single block physical read" event. Cache hits should be
--              under 1ms while missed will be on the order of a few ms.
--
--              In fact, the results may be wildy overstated in cases where
--              objects are aggressively cached in ESFC due to the storage
--              parameter CELL_FLASH_CACHE being set to KEEP, as this causes
--              Smart Scans to use the flash cache as well.
--
--              See kerryosborne.oracle-guy.com for additional information.
---------------------------------------------------------------------------------------
set pages 999
set lines 140

column c1 heading 'Event|Name'             format a30 trunc
column c2 heading 'Total|Waits'            format 99,999,999
column c3 heading 'Seconds|Waiting'        format 9,999,999
column c5 heading 'Average|Wait|(ms)' format 9999.9
column c6 heading 'Flash Cache Hits' for 999,999,999,999
col hit_ratio heading 'Hit Ratio' for 999.999


select 
 'cell single + multiblock reads' c1,
 c2, c3, c5, c6, 
 c6/decode(nvl(c2,0),0,1,c2) hit_ratio
from (
select
   sum(total_waits)                   c2,
   avg(value)                         c6,
   sum(time_waited / 100)             c3,
   avg((average_wait /100)*1000)          c5
from 
   sys.v_$system_event, v$sysstat ss
where 
   event in (
 'cell single block physical read', 
             'cell multiblock physical read')
and
    name like 'cell flash cache read hits'
and
   event not like '%Idle%')
order by 
   c3 
;
ttitle off
