
SELECT 'HEAP:' || relname AS table_name,(heap_blks_read + heap_blks_hit) AS heap_hits,
ROUND(((heap_blks_hit)::NUMERIC / (heap_blks_read + heap_blks_hit) * 100), 2) AS
heap_buffer_percentage FROM pg_statio_user_tables WHERE (heap_blks_read + heap_blks_hit) > 0

UNION

SELECT 'TOAST:' || relname, (toast_blks_read + toast_blks_hit),
ROUND(((toast_blks_hit)::NUMERIC / (toast_blks_read + toast_blks_hit) * 100), 2)
FROM pg_statio_user_tables WHERE (toast_blks_read + toast_blks_hit) > 0

UNION

SELECT 'INDEX:' || relname,(idx_blks_read + idx_blks_hit) AS heap_hits,
ROUND(((idx_blks_hit)::NUMERIC / (idx_blks_read + idx_blks_hit) * 100),2)
FROM pg_statio_user_tables WHERE (idx_blks_read + idx_blks_hit) > 0 order by heap_buffer_percentage DESC
