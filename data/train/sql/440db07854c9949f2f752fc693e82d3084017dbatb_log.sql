/*
1-jan-10,lau@ciysys.com
- This table stores the application log or process log. For example, when a nightly job is running
  it will append a record on when the process starts and stops.
  

*/

if not exists(
	select *
	from sys.objects
	where name = 'tb_log'
)
begin

	CREATE TABLE tb_log (
		log_id BIGINT NOT NULL,
		log_type_id INT NOT NULL,
		workstation NVARCHAR(255) NOT NULL,
		uid NVARCHAR(255) NOT NULL,
		msg NVARCHAR(MAX) NULL,
		remarks NVARCHAR(255) NULL,
		is_sent INT NOT NULL,
		app_id INT NOT NULL,
		module_id INT NOT NULL,
		
		modified_on DATETIME NOT NULL,
		modified_by NVARCHAR(255) NOT NULL,
		created_on DATETIME NOT NULL,
		created_by NVARCHAR(255) NOT NULL
	);

end
go

if not exists(
	select *
	from sys.objects
	where name = 'PK_tb_log'
)
begin

	ALTER TABLE tb_log 
	ADD CONSTRAINT PK_tb_log 
	PRIMARY KEY (
		log_id
	);

end
go

if not exists(
	select *
	from sys.indexes
	where name = 'IX_tb_log_2'
)
begin
	CREATE INDEX IX_tb_log_2 ON tb_log (log_type_id);
end
go

if not exists(
	select *
	from sys.indexes
	where name = 'PK_tb_log'
)
begin

	CREATE INDEX IX_tb_log_3 ON tb_log (app_id);

end
go

if not exists(
	select *
	from sys.indexes
	where name = 'IX_tb_log_4'
)
begin

	CREATE INDEX IX_tb_log_4 ON tb_log (module_id);
	
end
go

