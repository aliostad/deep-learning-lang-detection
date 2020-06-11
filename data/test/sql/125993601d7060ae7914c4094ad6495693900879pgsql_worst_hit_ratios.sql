-- Mostra as tabelas com os piores indices de cache

SELECT
	relname,
	heap_blks_read + heap_blks_hit AS heap_blk_requests,
	CASE 
		WHEN heap_blks_hit > 0
		THEN round(100.0-100.0*heap_blks_read/(heap_blks_read+heap_blks_hit),2)
		ELSE round(0.0,2)
	END AS heap_blks_hit_percent,
	idx_blks_read + idx_blks_hit AS idx_blk_requests,
	CASE
		WHEN idx_blks_hit > 0
		THEN round(100.0-100.0*idx_blks_read/(idx_blks_read + idx_blks_hit),2)
		ELSE round(0.0,2)
	END AS idx_blks_hit_percent
FROM
	pg_statio_user_tables
WHERE
	heap_blks_read > 0
ORDER BY
	heap_blks_hit_percent ASC
LIMIT 15