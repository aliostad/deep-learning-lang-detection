/********************************************************************
Author: Thomas Stringer
Created on: 4/27/2012

Description:
	creates a new server group for a central management server

Notes:
	- set @new_server_group_name to the desired group name
********************************************************************/

declare @new_server_group_name sysname = 'YourServerGroup'
declare @new_sg_id int
exec msdb.dbo.sp_sysmanagement_add_shared_server_group
	@name = @new_server_group_name,
	@parent_id = 1,		-- parent db engine
	@server_type = 0,	-- db engine
	@server_group_id = @new_sg_id output
select @new_sg_id as new_server_group_id
go