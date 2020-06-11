/**********************************************************
Author: Thomas Stringer
Created on: 4/5/2012

Description:
	alters the read and write state of the database

Notes:
	replace 'YourDatabase' with your database you are 
	attempting to alter
**********************************************************/
use master
go

-- put database in READ_ONLY
alter database YourDatabase
set read_only
with rollback immediate
go

-- put database in READ_WRITE
alter database YourDatabase
set read_write
with rollback immediate
go