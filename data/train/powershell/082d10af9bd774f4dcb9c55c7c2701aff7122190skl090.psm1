###############################################################################
# skl090.psm1 
#
#
###############################################################################
function insert_message {
	Param(
		[int]			$status = 0,
		[string]	$facility = "",
		[int]			$priority = 0,
		[string]	$message = ""
	)
	$query = @"
		insert into
			tbl_messages (
				ymdhms, status, facility, priority, message
		) values (
				sysdatetime(), $status, '$facility', $priority, '$message'
		);
"@
	sqlcmd -E -S $server_name -d $database -Q $query -u -b -w 80 -W | Out-Null
}
