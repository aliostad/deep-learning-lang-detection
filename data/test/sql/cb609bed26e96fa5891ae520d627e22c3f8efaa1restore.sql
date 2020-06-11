SET search_path TO tablelog_benchmark,public;

-- SELECT table_log_restore_table('test','i','test_log','trigger_id',
--    'restore_start_middle',(SELECT time FROM time),NULL,0,1);

SELECT table_log_restore_view('test_log','i','restore_view_start','2000-1-1');
SELECT table_log_restore_view('test_log','i','restore_view_middle',(SELECT time FROM time));
SELECT table_log_restore_view('test_log','i','restore_view_end',now());

EXPLAIN ANALYZE SELECT * FROM restore_view_start;
EXPLAIN ANALYZE SELECT * FROM restore_view_middle;
EXPLAIN ANALYZE SELECT * FROM restore_view_end;

DROP VIEW restore_view_start;
DROP VIEW restore_view_middle;
DROP VIEW restore_view_end;

