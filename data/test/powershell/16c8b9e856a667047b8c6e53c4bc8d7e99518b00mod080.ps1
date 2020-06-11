[string]$server_name = ".\sqlexpress"
[string]$database = "tsystem"
[string]$table = "tbl_messages"

function insert_message {
	Param(
		[int] $status = 0,
		[string] $facility = "",
		[int] $priority = 0,
		[string] $message = ""
	)
	$ymdhms = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
	#			--'$ymdhms', $status, '$facility', $priority, '$message'
	$query = @"
		insert into
			tbl_messages (
				ymdhms, status, facility, priority, message
		) values (
				sysdatetime(), $status, '$facility', $priority, '$message'
		);
"@
	sqlcmd -E -S $server_name -d $database -Q $query -u -b -w 80 -W | Out-Null
	return $LastExitCode
}

function select_messages {
	$query = @"
		select
			ymdhms, status, facility, priority, message
		from
			tbl_messages
		order by
			ymdhms
		;
"@
	sqlcmd -E -S $server_name -d $database -Q $query -u -b -w 100 -W
	return $LastExitCode
}
