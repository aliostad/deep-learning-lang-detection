prompt considera os ultimos 10 minutos
prompt 
SELECT tablespace_name, 
	intsize_csec / 100 sample_time,
	ROUND(AVG(average_read_time) * 10, 2) avg_read_time_ms,
	ROUND(AVG(average_write_time) * 10, 2) avg_write_time_ms,
	SUM(physical_reads) physical_reads,
	SUM(physical_writes) physical_writes,
	ROUND((SUM(physical_reads) + SUM(physical_writes)) * 100 / SUM(SUM(physical_reads) + SUM(physical_writes)) OVER (), 2) pct_io,
	CASE
		WHEN SUM(physical_reads) > 0 THEN
		ROUND(SUM(physical_block_reads) /SUM(physical_reads),2)
	END blks_per_read
FROM v$filemetric 
	JOIN dba_data_files
		USING (file_id)
GROUP BY tablespace_name, end_time, intsize_csec
ORDER BY 7 DESC;