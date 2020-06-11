-- Lista as tabelas pela utilizacao e mostra o nivel de cache de cada uma,
-- assim como seu tamanho

SELECT
	ps.relname,
	ps.heap_blks_read + ps.heap_blks_hit AS heap_blk_requests,
	CASE
		WHEN ps.heap_blks_hit > 0
		THEN round(100.0-100.0*ps.heap_blks_read/(ps.heap_blks_read+ps.heap_blks_hit),2)
		ELSE round(0.0,2)
	END AS heap_blks_hit_percent,
	ps.idx_blks_read + ps.idx_blks_hit AS idx_blk_requests,
	CASE
		WHEN ps.idx_blks_hit > 0
		THEN round(100.0-100.0*ps.idx_blks_read/(ps.idx_blks_read + ps.idx_blks_hit),2)
		ELSE round(0.0,2)
	END AS idx_blks_hit_percent,
	(pc.relpages::bigint * 8192)/1048576 as size_in_mb
FROM
	pg_statio_user_tables ps
		INNER JOIN pg_class pc ON pc.oid = ps.relid
WHERE
	ps.heap_blks_read > 0
ORDER BY
	heap_blk_requests desc