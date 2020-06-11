INSERT INTO os.ao_queue
        (queue_id, status, queue_date, start_date, end_date, error_message, num_rows,
        id, refresh_type,                 
        target_schema_name, target_table_name, target_append_only, target_compressed, target_row_orientation,
        source_type, source_server_name, source_instance_name, source_port, source_database_name, 
        source_schema_name, source_table_name, source_user_name, source_pass,
        column_name, sql_text, snapshot)
SELECT  queue_id, status, queue_date, start_date, end_date, error_message, num_rows,
        id, refresh_type,                 
        (target).schema_name, (target).table_name, false as append_only, false as target_compressed, true as target_row_orientation,
        (source).type, (source).server_name, (source).instance_name, (source).port, (source).database_name, 
        (source).schema_name, (source).table_name, (source).user_name, (source).pass,
        column_name, sql_text, coalesce(snapshot, false) AS snapshot
FROM :os_backup.queue;

INSERT INTO os.ao_ext_connection
SELECT * FROM :os_backup.ext_connection;

SELECT setval('os.ao_job_id_seq', i, true) 
FROM (SELECT max(id) AS i FROM :os_backup.job) AS sub;

SELECT setval('os.ao_ext_connection_id_seq', i, true) 
FROM (SELECT max(id) AS i FROM :os_backup.ext_connection) AS sub;

SELECT setval('os.ao_queue_queue_id_seq', i, true) 
FROM (SELECT max(queue_id) AS i FROM :os_backup.queue) AS sub;
