/*
Step 2
In Greenplum, execute the following as gpadmin
*/
        TRUNCATE os.job;
        TRUNCATE os.queue;

        DROP SCHEMA IF EXISTS os_demo cascade;

--Refresh
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('refresh',
                ('os_demo', 'sql_refresh'),
		('sqlserver', 'jonnywin', null, null, 'os_demo', 'dbo', 'refresh_test', 'os_test', 'os_password'));
--Append
        INSERT INTO os.job(
                refresh_type, target, source, column_name)
        VALUES ('append',
                ('os_demo', 'sql_append'),
		('sqlserver', 'jonnywin', null, null, 'os_demo', 'dbo', 'append_test', 'os_test', 'os_password'), 'id');

--Replication 
        INSERT INTO os.job(
                refresh_type, target, source, column_name, snapshot)
        VALUES ('replication',
                ('os_demo', 'sql_replication'),
                ('sqlserver', 'jonnywin', null, null, 'os_demo', 'dbo', 'replication_test', 'os_test', 'os_password'), 'repl_id', false);

--DDL
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('ddl',
                ('os_demo', 'sql_refresh_ddl_only'),
		('sqlserver', 'jonnywin', null, null, 'os_demo', 'dbo', 'refresh_test', 'os_test', 'os_password'));


SELECT os.fn_queue_all();
