INSERT INTO os.ao_job
        (id, refresh_type,                 
        target_schema_name, target_table_name, target_append_only, target_compressed, target_row_orientation,
        source_type, source_server_name, source_instance_name, source_port, source_database_name, 
        source_schema_name, source_table_name, source_user_name, source_pass,
        column_name, sql_text, snapshot)
SELECT  id, refresh_type,                 
        (target).schema_name, (target).table_name, false AS append_only, false AS target_compressed, true AS target_row_orientation,
        (source).type, (source).server_name, (source).instance_name, (source).port, (source).database_name, 
        (source).schema_name, (source).table_name, (source).user_name, (source).pass,
        column_name, sql_text, coalesce(snapshot, false) AS snapshot
FROM :os_backup.job
WHERE refresh_type in ('append', 'refresh', 'replication', 'transform', 'ddl');
