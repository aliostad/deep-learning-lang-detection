if exists(select * from sys.objects where name = 'pr_sys_append_log')
	drop proc pr_sys_append_log
go

create proc pr_sys_append_log (
	@msg nvarchar(max),
	
	-- optional param
	@log_type_id int = 4,			-- 1-err,2-info, 3-warning, 4-audit log, 5-critical
	@remarks nvarchar(255) = '',		
	@uid nvarchar(255) = '',
	
	@is_sent int = 0,
	@app_id int = 0,
	@module_id int = 0
)
as
begin

/*
4-jul-11,lau@ciysys.com
- append the log record to tb_log table.

sample:

	exec pr_sys_append_log
		'testing',

		-- below are optional.	
		4,
		'this is remarks',
		'tester',
		1,
		2,
		3

*/
	-- ==========================================================
	-- init
	-- ==========================================================
	set nocount on

	declare 
		@log_id bigint

	exec pr_sys_gen_new_id 
		'tb_log',
		@log_id output

	-- ==========================================================
	-- process
	-- ==========================================================
	insert into tb_log (
		log_id,log_type_id,workstation,
		uid,msg,remarks,
		is_sent,app_id,module_id,
		modified_on,modified_by,created_on,created_by
	)

	select 
		@log_id,		
		@log_type_id,
		host_name(),

		@uid,
		@msg,
		@remarks,

		@is_sent,
		@app_id,
		@module_id,
		getdate(),
		@uid,
		getdate(),
		@uid

	-- ==========================================================
	-- cleanup
	-- ==========================================================

	set nocount off

end
go
