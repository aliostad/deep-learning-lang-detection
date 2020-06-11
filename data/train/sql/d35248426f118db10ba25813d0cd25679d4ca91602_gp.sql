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
                ('os_demo', 'hr_countries'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'HR', 'COUNTRIES', 'os_test', 'os_password'));
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('refresh',
                ('os_demo', 'hr_departments'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'HR', 'DEPARTMENTS', 'os_test', 'os_password'));
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('refresh',
                ('os_demo', 'hr_employees'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'HR', 'EMPLOYEES', 'os_test', 'os_password'));
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('refresh',
                ('os_demo', 'hr_job_history'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'HR', 'JOB_HISTORY', 'os_test', 'os_password'));
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('refresh',
                ('os_demo', 'hr_jobs'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'HR', 'JOBS', 'os_test', 'os_password'));
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('refresh',
                ('os_demo', 'hr_locations'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'HR', 'LOCATIONS', 'os_test', 'os_password'));
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('refresh',
                ('os_demo', 'hr_regions'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'HR', 'REGIONS', 'os_test', 'os_password'));
--Append
        INSERT INTO os.job(
                refresh_type, target, source, column_name)
        VALUES ('append',
                ('os_demo', 'append_test'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'OS_TEST', 'APPEND_TEST', 'os_test', 'os_password'), 'ID');

--Replication 
        INSERT INTO os.job(
                refresh_type, target, source, column_name, snapshot)
        VALUES ('replication',
                ('os_demo', 'replication_test'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'OS_TEST', 'REPLICATION_TEST', 'os_test', 'os_password'), 'REPL_ID', false);
--DDL
        INSERT INTO os.job(
                refresh_type, target, source)
        VALUES ('ddl',
                ('os_demo', 'countries_ddl_only'),
                ('oracle', 'jonnywin', null, 1521, 'xe', 'HR', 'COUNTRIES', 'os_test', 'os_password'));


SELECT os.fn_queue_all();
