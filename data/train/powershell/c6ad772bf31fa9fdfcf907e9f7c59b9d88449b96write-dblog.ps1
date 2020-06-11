<#

.SYNOPSIS
	Account management database logging
.DESCRIPTION
	Function that will log the given message into the account management logging database and table
.NOTES
	File Name	:	write-dblog.ps1
	Author		:	Kris Hagel - kris@krishagel.com
	Date		:	August 10, 2012
.LINK
	https://github.com/krishagel/edage
.EXAMPLE
	write-dblog -header "Staff Add" -message "Initialization" -account "HAGELKRI000"
	Will write a record into the database with the following header, message, and account.
	
#>

function write-dblog
{
	Param(
	[string]$header,
	[string]$message,
	[string]$account
	)

	# Open the database connection
	$conn = New-MySQLConnection -server $dbserver -user $dbuser -password $dbpass -database $log_db
	
	# Insert log record into the database
	$result = Invoke-MySQLQuery "INSERT INTO $log_tbl (header, message, account, mod_date) VALUES (@header, @message, @account, NOW())" -param  @{header=$header;message=$message;account=$account} -conn $conn	
}