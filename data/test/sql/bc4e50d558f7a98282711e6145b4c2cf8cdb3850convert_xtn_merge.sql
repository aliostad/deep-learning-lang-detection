ALTER SESSION ENABLE PARALLEL DML;

/* The cutoff time is added to prevent scanning old data, but the value is not
   that important as long as it's not too old
*/

MERGE /*+ APPEND PARALLEL */ INTO xtn2 USING (
	SELECT HEXTORAW(xtn.xtn_id) AS xtn_id, xtn.username, xtn.command, xtn.is_readonly, xtn.start_time
	FROM xtn
	WHERE xtn.start_time > TO_DATE('2016-05-14', 'YYYY-MM-DD')
) x ON (xtn2.id = x.xtn_id)
	WHEN NOT MATCHED THEN INSERT (id, username, command, is_readonly, start_time)
		VALUES (x.xtn_id, x.username, x.command, x.is_readonly, x.start_time);
COMMIT;

MERGE /*+ APPEND PARALLEL */ INTO xtn2_detail USING (
	SELECT HEXTORAW(xtn_detail.xtn_id) AS xtn_id, xtn_detail.name, xtn_detail.value
	FROM xtn_detail
		JOIN xtn ON xtn_detail.xtn_id = xtn.xtn_id
	WHERE xtn.start_time > TO_DATE('2016-05-14', 'YYYY-MM-DD')
) x ON (xtn2_detail.xtn_id = x.xtn_id AND xtn2_detail.name = x.name AND xtn2_detail.value = x.value)
	WHEN NOT MATCHED THEN INSERT (xtn_id, name, value)
		VALUES (x.xtn_id, x.name, x.value);
COMMIT;

MERGE /*+ APPEND PARALLEL */ INTO xtn2_end USING (
	SELECT HEXTORAW(xtn_end.xtn_id) AS xtn_id, xtn_end.return_code, xtn_end.end_time
	FROM xtn_end
		JOIN xtn ON xtn_end.xtn_id = xtn.xtn_id
	WHERE xtn.start_time > TO_DATE('2016-05-14', 'YYYY-MM-DD')
) x ON (xtn2_end.xtn_id = x.xtn_id)
	WHEN NOT MATCHED THEN INSERT (xtn_id, return_code, end_time)
		VALUES (x.xtn_id, x.return_code, x.end_time);
COMMIT;

QUIT;
