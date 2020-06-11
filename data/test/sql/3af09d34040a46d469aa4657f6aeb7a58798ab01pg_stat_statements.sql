SELECT
	a.rolname
	,d.datname
	,s.query
	,s.calls
	,ROUND(s.total_time::numeric, 3) as total_time_ms
	,ROUND((s.total_time / SUM(s.total_time) OVER() * 100)::numeric, 2) as "total_time %"
	,( interval '1 millisecond' * ROUND(s.total_time::numeric) )::text as total_time_hr
	,ROUND( (s.total_time / s.calls)::numeric, 3) as avg_query_time_ms
	,( interval '1 millisecond' * ROUND( (s.total_time / s.calls)::numeric) )::text as avg_query_time_hr
	,s.rows
	,s.rows / s.calls as avg_rows
	,s.shared_blks_hit
	,s.shared_blks_read
	,s.shared_blks_dirtied
	,s.shared_blks_written
	,s.local_blks_hit
	,s.local_blks_read
	,s.local_blks_dirtied
	,s.local_blks_written
	,s.temp_blks_read
	,s.temp_blks_written
	,s.blk_read_time
	,s.blk_write_time
--	,'|'
--	,s.*
FROM
	pg_stat_statements s
	JOIN pg_authid a ON (a.oid = s.userid)
	JOIN pg_database d ON (d.oid = s.dbid)
WHERE
	s.total_time >= 1 -- Longer 1 ms. To do not show SET, LOCL, DISCARD statements
ORDER BY
	total_time_ms DESC, total_time DESC
/

SELECT pg_stat_statements_reset()