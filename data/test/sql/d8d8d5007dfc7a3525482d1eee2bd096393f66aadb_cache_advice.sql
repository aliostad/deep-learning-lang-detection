set linesize 250
set pages 50000

column block_size format a10 heading "Block Size"
column instance format a15 heading "Instance"
column size_for_estimate format 9G999G990D99 heading "Cache Size (MB)"
column estd_physical_read_factor format 990D999 heading "Factor"
column estd_physical_reads format 99G999G999G999G990 heading "Est Phys Reads"
column estd_phys_reads_delta format 999G999G999G990 heading "Est Phys Reads Del"
column estd_cluster_reads format 99G999G999G999G990 heading "Est Clust Reads"
column estd_cls_reads_delta format 999G999G999G990 heading "Est Clust Reads Del"
column estd_physical_read_time format 9G999G999G990 heading "Est Phys Read Time"
column estd_phys_read_time_delta format 9G999G999G990 heading "Est Phys Read Time Del"
column estd_pct_of_db_time_for_reads format 9990D99 heading "Est % read"
column estd_cluster_read_time format 9G999G999G990 heading "Est Clust Read Time"
column estd_cls_read_time_delta format 9G999G999G990 heading "Est Clust Read Time Del"

break on name skip 2 on block_size on instance skip 1

with current_size as
( select
    inst_id,
    block_size,
    estd_physical_reads,
    estd_physical_read_time,
    estd_cluster_reads,
    estd_cluster_read_time
  from
    gv$db_cache_advice
  where
    advice_status = 'ON'
    and estd_physical_read_factor = 1
)
select
  ca.block_size || decode(name, 'DEFAULT', ' (*)') block_size,
  ca.inst_id || ' (' || to_char(inst.startup_time, 'DD/MM/YYYY') || ')'   instance, 
  ca.size_for_estimate, 
  ca.estd_physical_read_factor, 
  ca.estd_pct_of_db_time_for_reads,
  ca.estd_physical_reads,
  (ca.estd_physical_reads - cs.estd_physical_reads) estd_phys_reads_delta,
  ca.estd_physical_read_time,
  ( ca.estd_physical_read_time - cs.estd_physical_read_time) estd_phys_read_time_delta,
  ca.estd_cluster_reads,
  (ca.estd_cluster_reads - cs.estd_cluster_reads) estd_cls_reads_delta,
  ca.estd_cluster_read_time,
  ( ca.estd_cluster_read_time - cs.estd_cluster_read_time) estd_cls_read_time_delta
from
  gv$db_cache_advice  ca,
  current_size        cs,
  gv$instance         inst
where
  ca.block_size = cs.block_size
  and ca.inst_id = cs.inst_id
  and inst.inst_id = ca.inst_id
  and ca.advice_status = 'ON'
order by
  ca.block_size,
  ca.inst_id,
  ca.size_for_estimate
;

clear breaks
