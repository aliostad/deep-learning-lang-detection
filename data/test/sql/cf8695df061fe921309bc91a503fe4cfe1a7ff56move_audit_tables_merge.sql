ALTER SESSION ENABLE PARALLEL DML;

MERGE /*+ APPEND PARALLEL */ INTO xtn2 USING xtn ON (xtn2.xtn_id = xtn.xtn_id)
	WHEN NOT MATCHED THEN INSERT (xtn_id, username, command, is_readonly, start_time)
		VALUES (xtn.xtn_id, xtn.username, xtn.command, xtn.is_readonly, xtn.start_time);
COMMIT;

MERGE /*+ APPEND PARALLEL */ INTO xtn2_detail USING xtn_detail ON (xtn2_detail.xtn_id = xtn_detail.xtn_id AND xtn2_detail.name = xtn_detail.name AND xtn2_detail.value = xtn_detail.value)
	WHEN NOT MATCHED THEN INSERT (xtn_id, name, value)
		VALUES (xtn_detail.xtn_id, xtn_detail.name, xtn_detail.value);
COMMIT;

MERGE /*+ APPEND PARALLEL */ INTO xtn2_end USING xtn_end ON (xtn2_end.xtn_id = xtn_end.xtn_id)
	WHEN NOT MATCHED THEN INSERT (xtn_id, return_code, end_time)
		VALUES (xtn_end.xtn_id, xtn_end.return_code, xtn_end.end_time);
COMMIT;

QUIT;
