CREATE TABLE new_employees
(
	id_num int IDENTITY(1,1),
	fname varchar (20),
	minit char(1),
	lname varchar(30)
)

create index IX_Name
	on new_employees (lname, fname)

CREATE TABLE new_employeesnew
(
	id_num int NOT NULL,
	fname varchar (20),
	minit char(1),
	lname varchar(30)
)

create index IX_Name
	on new_employeesnew (lname, fname)


INSERT new_employees
	(fname, minit, lname)
VALUES
	('Karin', 'F', 'Josephs')

INSERT new_employees
	(fname, minit, lname)
VALUES
	('Pirkko', 'O', 'Koskitalo')


ALTER TABLE new_employees SWITCH TO new_employeesnew

select * from new_employees

select * from new_employeesnew

drop table new_employees

exec sp_rename 'new_employeesnew', 'new_employees', 'object'

select * from new_employees

select * from sys.indexes where object_id = object_id('new_employees')

/*
if exists(select * from sys.objects where name = 'new_employees')
drop table new_employees

if exists(select * from sys.objects where name = 'new_employeesnew')
drop table new_employeesnew
*/

exec sp_spaceused

select top 20 object_name(id), dpages/128.
from sysindexes
where indid < 2
order by 2 desc

exec sp_rename 'DBMonitoringTestResult', 'DBMonitoringTestResult3', 'object'

exec sp_rename 'DBMonitoringTestResult3', 'DBMonitoringTestResult', 'object'