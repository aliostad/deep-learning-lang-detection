CREATE TABLE os.ao_queue
(
  queue_id serial NOT NULL,
  status text NOT NULL check(status in ('queued', 'success', 'failed', 'processing')),
  queue_date timestamp without time zone NOT NULL,
  start_date timestamp without time zone,
  end_date timestamp,
  error_message text,
  num_rows int not null default 0,
--from os.job
  id int NOT NULL,
  refresh_type text NOT NULL,
  
  target_schema_name text,
  target_table_name text,
  target_append_only boolean NOT NULL,
  target_compressed boolean NOT NULL,
  target_row_orientation boolean NOT NULL,
  
  source_type text, 
  source_server_name text,
  source_instance_name text,
  source_port int, 
  source_database_name text,
  source_schema_name text,
  source_table_name text,
  source_user_name text,
  source_pass text,
  
  column_name text,
  sql_text text,
  snapshot boolean NOT NULL,
  deleted boolean NOT NULL DEFAULT FALSE,
  insert_id serial NOT NULL)
 WITH (appendonly=true)
:DISTRIBUTED_BY;
 --DISTRIBUTED BY (queue_id);

CREATE VIEW os.queue AS
SELECT queue_id, status, queue_date, start_date, end_date, error_message, 
       num_rows, id, refresh_type, target_schema_name, target_table_name, 
       target_append_only, target_compressed, target_row_orientation, 
       source_type, source_server_name, source_instance_name, source_port, 
       source_database_name, source_schema_name, source_table_name, 
       source_user_name, source_pass, column_name, sql_text, snapshot
FROM    (
        SELECT queue_id, status, queue_date, start_date, end_date, error_message, 
               num_rows, id, refresh_type, target_schema_name, target_table_name, 
               target_append_only, target_compressed, target_row_orientation, 
               source_type, source_server_name, source_instance_name, source_port, 
               source_database_name, source_schema_name, source_table_name, 
               source_user_name, source_pass, column_name, sql_text, snapshot,
               row_number() OVER (PARTITION BY queue_id ORDER BY insert_id DESC) AS rownum, deleted
        FROM os.ao_queue
        ) AS sub
WHERE rownum = 1 AND NOT deleted;
