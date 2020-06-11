/*
Step 3
After all jobs complete in the queue, check the tables:
select * from os.queue order by status;

*/
--refresh
select * from os_demo.hr_countries;
select * from os_demo.hr_departments;
select * from os_demo.hr_employees;
select * from os_demo.hr_job_history;
select * from os_demo.hr_jobs;
select * from os_demo.hr_regions;
--append (notice there are 5 rows)
select * from os_demo.append_test order by id;
--replication (notice there are 5 rows and the salaries)
select * from os_demo.replication_test order by id;
