col size_for_estimate  heading "Cache Size" format 999999
col size_factor_pct  heading "Relative Size pct" format 999999
col estd_physical_read_factor_pct heading "Relative Phys Rds" format 999999 
col estd_physical_reads heading "Estimated Phys Reads" format 999999
col estd_physical_read_time heading "Estimated Read Time" format 999999
col estd_pct_of_db_time_for_reads heading "Estimated Pct Phys Rds Pct of DB Time" format 999999

prompt onde size_
prompt DEFAULT e 8192
SELECT size_for_estimate, 
	size_factor * 100 size_factor_pct,
	estd_physical_read_factor * 100 estd_physical_read_factor_pct,
	estd_physical_reads, 
	estd_physical_read_time,
	estd_pct_of_db_time_for_reads
FROM v$db_cache_advice
WHERE name = 'DEFAULT' 
 AND block_size=8192
ORDER BY size_for_estimate;