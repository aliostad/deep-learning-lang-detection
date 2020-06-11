
/* Procedure copyright(c) 1995 by Edward M Barlow */

/******************************************************************************
**
** Name        : sp__iostat
**
******************************************************************************/
:r database
go
:r dumpdb
go

if exists (select * from sysobjects
           where  name = "sp__iostat"
           and    type = "P")
   drop proc sp__iostat
go

/*---------------------------------------------------------------------------*/

create proc sp__iostat( @cnt int=3, @seconds_delay int=10, 
	@dont_format char(1) = null
	)
AS 
BEGIN

/* Process Stats */

declare @seconds_delaystr char(10)
set nocount on

create table #tmp
(
	spid 		smallint,
	suid 		smallint,

	cmd		char(16) null,
	cpu		int null,
	physical_io	int null,
	memusage	int null,

	new_cmd		char(16) null,
	new_cpu		int null,
	new_physical_io	int null,
	new_memusage	int null,
	blocked  smallint null,
	p_cpu char(6) null,
	p_io	char(4) null,
	p_mem char(4) null,
	p_state char(4) null
)

/*
Loop
	Fill With Any New Rows (new=-1, state='New')
	Update all rows with newest data
	If Any Changes, modify & print them
	Delete if new=-1 (dead rows)
	Save Data & Set new=-1,state=''
	Wait
End Loop
*/


While @cnt > 0
begin
	/* Insert Processes that are not in #tmp already */
	insert 	#tmp
	select 	spid,suid,cmd,cpu,physical_io,memusage,
		 		cmd,-1,-1,-1,blocked, null,null,null,'New'
	from 		master..sysprocesses
	where	 	spid!=@@spid
	and		spid*1000 + suid not in ( select spid*1000+suid from #tmp )

	update #tmp
	set 	new_cmd=p.cmd,
			new_cpu=p.cpu,
			new_physical_io=p.physical_io,
			new_memusage=p.memusage,
		 	blocked=p.blocked
	from master..sysprocesses p,#tmp t
	where p.spid = t.spid
	and   p.suid = t.suid

	/* new_cpu = -1 is dead row, any with cpu is active or new */

	/* If Any Rows Changed, Print Them */
	if not exists ( select * 
			from #tmp
			where new_cpu-cpu != 0
				or new_physical_io-physical_io != 0
				or blocked=1)
	begin
		select convert(char(8),getdate(),8), "No Change"
	end
	else
	begin
		update #tmp
		set	
			p_cpu     = convert(char(6),new_cpu-cpu),
			p_io      = convert(char(4),new_physical_io-physical_io),
			p_mem     = convert(char(4),new_memusage-memusage)
		where new_cpu >= 0

		update 	#tmp
			set 	p_cpu = "N.A." 
			where new_cpu-cpu < 0
		   and 	new_cpu >= 0

		update 	#tmp
			set 	p_io = "N.A." 
			where new_physical_io-physical_io  < 0
		   and 	new_cpu >= 0

		update 	#tmp
			set 	p_mem = "N.A." 
			where new_memusage-memusage  < 0
		   and 	new_cpu >= 0

		update #tmp
			set p_cpu = "NEW",
			    p_io = "NEW",
			    p_mem = "NEW"
			where p_state='New'

		update #tmp
			set p_cpu = "DEAD",
			    p_io = "DEAD",
			    p_mem = "DEAD"
			where new_cpu = -1

		select 
			"Time"  = convert(char(8),getdate(),8),
			Spid	  = convert(char(4),spid),
			"Login" = convert(char(13),suser_name(suid)), 
			Cmd     = new_cmd,
			Cpu     = p_cpu,
			Io      = p_io,
			Mem     = p_mem,
		 	Blk     = blocked
		from #tmp
		where new_cpu-cpu 	!= 0
			or new_physical_io-physical_io != 0
			or blocked			=	1
			/* or new_cmd not in ( 'NETWORK HANDLER', 'MIRROR HANDLER',
				'CHECKPOINT SLEEP', 'AWAITING COMMAND' ) */
	end

	delete #tmp
		where new_cpu = -1
			
	/* Save Vbls */
	update #tmp
	set 	cmd 			=	new_cmd,
			cpu 			=	new_cpu,
			physical_io	=	new_physical_io,
			memusage 	=	new_memusage,
			new_cpu = -1, 
			p_state=""

	select @cnt = @cnt - 1
	if @seconds_delay=5
		waitfor delay '00:00:05'
	else if @seconds_delay=10
		waitfor delay '00:00:10'
	else if @seconds_delay=3
		waitfor delay '00:00:03'
	else if @seconds_delay=30
		waitfor delay '00:00:30'
	else if @seconds_delay=60
		waitfor delay '00:01:00'
	else
		waitfor delay '00:00:01'
end

drop table #tmp

return(0)

END
go
grant execute on sp__iostat  TO public
go
