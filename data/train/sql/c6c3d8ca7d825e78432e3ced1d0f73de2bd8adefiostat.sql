select
  snap_id,
  small_read_megabytes,
  small_write_megabytes,
  large_read_megabytes,
  large_write_megabytes,
  small_read_reqs,
  small_write_reqs,
  small_sync_read_reqs,
  large_read_reqs,
  large_write_reqs,
  small_read_servicetime,
  small_write_servicetime,
  small_sync_read_latency,
  large_read_servicetime,
  large_write_servicetime,
  retries_on_error
from
  dba_hist_iostat_filetype
where
  filetype_name = 'Data File'
order by
  snap_id,
  filetype_name
;

select
  snap_id,
  small_read_servicetime,
  small_write_servicetime,
  large_read_servicetime,
  large_write_servicetime,
  retries_on_error
from
  dba_hist_iostat_filetype
where
  filetype_name = 'Data File'
order by
  snap_id,
  filetype_name
;
