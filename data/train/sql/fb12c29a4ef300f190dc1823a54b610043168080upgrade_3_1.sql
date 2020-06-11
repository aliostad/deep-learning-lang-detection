ALTER TABLE os.job DROP CONSTRAINT job_check;
ALTER TABLE os.queue DROP CONSTRAINT job_check;

ALTER TABLE os.job DROP CONSTRAINT job_refresh_type;
ALTER TABLE os.queue DROP CONSTRAINT job_refresh_type;

ALTER TABLE os.job
  ADD CONSTRAINT job_check
  CHECK ((refresh_type = 'refresh'::text AND column_name IS NULL AND snapshot IS NULL AND sql_text IS NULL
          AND (source).type IN ('oracle'::text, 'sqlserver'::text) AND (source).server_name IS NOT NULL
          AND (source).database_name IS NOT NULL AND (source).schema_name IS NOT NULL
          AND (source).table_name IS NOT NULL AND (source).user_name IS NOT NULL
          AND (source).pass IS NOT NULL)  OR
         (refresh_type = 'append'::text AND column_name IS NOT NULL AND snapshot IS NULL AND sql_text IS NULL) OR
         (refresh_type = 'replication'::text AND column_name IS NOT NULL AND snapshot IS NOT NULL AND sql_text IS NULL) OR
         (refresh_type = 'transform' AND (source).type IS NULL AND (source).server_name IS NULL
          AND (source).instance_name IS NULL AND (source).port IS NULL
          AND (source).database_name IS NULL AND (source).schema_name IS NULL AND (source).table_name IS NULL AND (source).user_name IS NULL
          AND (source).pass IS NULL AND column_name IS NULL AND sql_text IS NOT NULL AND snapshot IS NULL ) OR
         (refresh_type = 'ddl'::text AND column_name IS NULL AND snapshot IS NULL AND sql_text IS NULL
          AND (source).type IN ('oracle'::text, 'sqlserver'::text) AND (source).server_name IS NOT NULL
          AND (source).database_name IS NOT NULL AND (source).schema_name IS NOT NULL
          AND (source).table_name IS NOT NULL AND (source).user_name IS NOT NULL
          AND (source).pass IS NOT NULL)
         );

ALTER TABLE os.queue
  ADD CONSTRAINT job_check
  CHECK ((refresh_type = 'refresh'::text AND column_name IS NULL AND snapshot IS NULL AND sql_text IS NULL
          AND (source).type IN ('oracle'::text, 'sqlserver'::text) AND (source).server_name IS NOT NULL
          AND (source).database_name IS NOT NULL AND (source).schema_name IS NOT NULL
          AND (source).table_name IS NOT NULL AND (source).user_name IS NOT NULL
          AND (source).pass IS NOT NULL)  OR
         (refresh_type = 'append'::text AND column_name IS NOT NULL AND snapshot IS NULL AND sql_text IS NULL) OR
         (refresh_type = 'replication'::text AND column_name IS NOT NULL AND snapshot IS NOT NULL AND sql_text IS NULL) OR
         (refresh_type = 'transform' AND (source).type IS NULL AND (source).server_name IS NULL
          AND (source).instance_name IS NULL AND (source).port IS NULL
          AND (source).database_name IS NULL AND (source).schema_name IS NULL AND (source).table_name IS NULL AND (source).user_name IS NULL
          AND (source).pass IS NULL AND column_name IS NULL AND sql_text IS NOT NULL AND snapshot IS NULL ) OR
         (refresh_type = 'ddl'::text AND column_name IS NULL AND snapshot IS NULL AND sql_text IS NULL
          AND (source).type IN ('oracle'::text, 'sqlserver'::text) AND (source).server_name IS NOT NULL
          AND (source).database_name IS NOT NULL AND (source).schema_name IS NOT NULL
          AND (source).table_name IS NOT NULL AND (source).user_name IS NOT NULL
          AND (source).pass IS NOT NULL)
         );

ALTER TABLE os.job ADD CONSTRAINT job_refresh_type
  CHECK (refresh_type in ('append', 'refresh', 'replication', 'transform', 'ddl'));

ALTER TABLE os.queue ADD CONSTRAINT job_refresh_type
  CHECK (refresh_type in ('append', 'refresh', 'replication', 'transform', 'ddl'));

