<#
getReport.ps1
Import data from Office365 and save it into a SQL database for reporting
E-mail log
 

#>

$scriptTitle = "Office365 Reporting"
$scriptName = $MyInvocation.MyCommand.Name
$scriptpath = $Myinvocation.Mycommand.Path

$emailFrom	= "SCRIPT@SMTP.LOCAL"
$emailTo	= "YOU@SMTP.LOCAL", "OTHER@SMTP.LOCAL"
$smtpServer = "YOUR.SMTP.LOCAL"

#PRODUCTION
$Username = "YOUR-SVC-ACCOUNT@YOUR.OFFICE365.DOMAIN"
$Password = ConvertTo-SecureString '*YOUR_PASSWORD*' -AsPlainText -Force
$scriptRoot = "C:\office365_reporting\batch"
$logRoot = "C:\office365_reporting\logs"

$UsageLocation = "US"

$log = New-Object -TypeName "System.Text.StringBuilder" "";


function writeLog {
	$exist = Test-Path $logRoot\getReport.log
	$logFile = New-Object System.IO.StreamWriter("$logRoot\getReport.log", $exist)
	$logFile.write($log)
	$logFile.close()
}

#[Connect]
try {
	$LiveCredential = New-Object System.Management.Automation.PSCredential $Username, $Password
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $LiveCredential -Authentication Basic -AllowRedirection -ErrorAction SilentlyContinue
 
	Import-PSSession $Session

	Connect-MsolService -Credential $LiveCredential


} catch { 
	[void]$log.appendline("Error - [Connect]")
	[void]$log.appendline($Error)
}

[void]$log.appendline((("[Start Batch - ")+(get-date)+("]")))

#[getReport]
try {

	$Recipients = Get-Recipient -ResultSize Unlimited | select PrimarySMTPAddress 
	$MailTraffic = @{} 
	foreach($Recipient in $Recipients) 
	{ 
		$MailTraffic[$Recipient.PrimarySMTPAddress.ToLower()] = @{} 
	} 
	
	[void]$log.appendline((("Get-Recipient - Recipients: $($Recipients.count) - ")+(get-date)+("]"))) 
	
	$Recipients = $null
	#Collect Message Tracking Logs (These are broken into "pages" in Office 365 so we need to collect them all with a loop) 
	$Messages = $null 
	$Page = 1 
	do 
	{ 
		Write-Verbose "Collecting Message Tracking - Page $Page..." 
		$CurrMessages = Get-MessageTrace -PageSize 5000 -Page $Page | Select Received,SenderAddress,RecipientAddress,Size
		$Page++ 
		$Messages += $CurrMessages 
	} 
	until ($CurrMessages -eq $null) 
	
	[void]$log.appendline((("Get-MessageTrace completed. - ")+(get-date)+("]"))) 	
	Remove-PSSession $session 
	 
	Write-Verbose "Crunching Results..." 
	 
	#Read each message tracking entry and add it to a hash table 
	foreach($Message in $Messages) 
	{ 
		if ($Message.SenderAddress -ne $null) 
		{ 
			if ($MailTraffic.ContainsKey($Message.SenderAddress)) 
			{ 
				$MessageDate = Get-Date -Date $Message.Received -Format yyyy-MM-dd 
				 
				if ($MailTraffic[$Message.SenderAddress].ContainsKey($MessageDate)) 
				{ 
					$MailTraffic[$Message.SenderAddress][$MessageDate]['Outbound']++ 
					$MailTraffic[$Message.SenderAddress][$MessageDate]['OutboundSize'] += $Message.Size
				} 
				else 
				{ 
					$MailTraffic[$Message.SenderAddress][$MessageDate] = @{} 
					$MailTraffic[$Message.SenderAddress][$MessageDate]['Outbound'] = 1 
					$MailTraffic[$Message.SenderAddress][$MessageDate]['Inbound'] = 0 
					$MailTraffic[$Message.SenderAddress][$MessageDate]['InboundSize'] = 0
					$MailTraffic[$Message.SenderAddress][$MessageDate]['OutboundSize'] += $Message.Size
				} 
				 
			} 
		} 
		 
		if ($Message.RecipientAddress -ne $null) 
		{ 
			if ($MailTraffic.ContainsKey($Message.RecipientAddress)) 
			{ 
				$MessageDate = Get-Date -Date $Message.Received -Format yyyy-MM-dd 
				 
				if ($MailTraffic[$Message.RecipientAddress].ContainsKey($MessageDate)) 
				{ 
					$MailTraffic[$Message.RecipientAddress][$MessageDate]['Inbound']++ 
					$MailTraffic[$Message.RecipientAddress][$MessageDate]['InboundSize'] += $Message.Size
				} 
				else 
				{ 
					$MailTraffic[$Message.RecipientAddress][$MessageDate] = @{} 
					$MailTraffic[$Message.RecipientAddress][$MessageDate]['Inbound'] = 1 
					$MailTraffic[$Message.RecipientAddress][$MessageDate]['Outbound'] = 0 
					$MailTraffic[$Message.RecipientAddress][$MessageDate]['OutboundSize'] = 0
					$MailTraffic[$Message.RecipientAddress][$MessageDate]['InboundSize'] += $Message.Size

				} 
			}     
		} 
	} 
	 

} catch { 
	[void]$log.appendline("Error - [getReport]")
	[void]$log.appendline($Error)
}

#[uploadReport]
try {
	Write-Verbose "Formatting Results..." 
		
	#Build a table to format the results 
	$table = New-Object system.Data.DataTable "DetailedMessageStats"  
	$col1 = New-Object system.Data.DataColumn Date,([datetime])  
	$table.columns.add($col1)  
	$col2 = New-Object system.Data.DataColumn Recipient,([string])  
	$table.columns.add($col2)  
	$col3 = New-Object system.Data.DataColumn Inbound,([int])  
	$table.columns.add($col3)  
	$col4 = New-Object system.Data.DataColumn Outbound,([int])  
	$table.columns.add($col4) 
	$col5 = New-Object system.Data.DataColumn InboundSize,([int])  
	$table.columns.add($col5)  
	$col6 = New-Object system.Data.DataColumn OutboundSize,([int])  
	$table.columns.add($col6)  
	  
	#Transpose hashtable to datatable  
	ForEach ($Recipient in $MailTraffic.keys)  
	{  
		$RecipientName = $Recipient  
		  
		foreach($Date in $MailTraffic[$RecipientName].keys)  
		{  
			$row = $table.NewRow()  
			$row.Date = $Date  
			$row.Recipient = $RecipientName  
			$row.Inbound = $MailTraffic[$RecipientName][$Date].Inbound  
			$row.Outbound = $MailTraffic[$RecipientName][$Date].Outbound  
			$row.InboundSize = $MailTraffic[$RecipientName][$Date].InboundSize 
			$row.OutboundSize = $MailTraffic[$RecipientName][$Date].OutboundSize 
			$table.Rows.Add($row)      
		}  
	}  
	
	[void]$log.appendline((("Formatted results into datatable. - MessageTrace Records: $($table.rows.count) - ")+(get-date)+("]")))
	 
	#$table | sort Date,Recipient,Inbound,Outbound, InboundSize, OutboundSize | Out-GridView -Title "Messages Sent By User"

	#$table | sort Date,Recipient,Inbound,Outbound, InboundSize, OutboundSize | export-csv $OutputFile 
	 
	if ($table.rows.count -gt 0) {

		$sqlsvr = "YOUR_SQL"
		
		Write-Verbose "Results saving in to SQL - $($sqlsvr)"
		
		$database = "NetworkReporting"
		$tableName = "[NetworkReporting].[dbo].[ImportEmailStats]"
		$user = "netrptinput"
		$pass = "*YOUR_PASSWORD*"
		$conn = New-Object System.Data.SqlClient.SqlConnection
		$conn.ConnectionString = "Data Source=$sqlsvr;Initial Catalog=$database; uid=$user;pwd=$pass"
		$conn.Open()
		$cmd = New-Object System.Data.SqlClient.SqlCommand
		$cmd.connection = $conn

		#load out-datatable function
		. "$scriptRoot\function_out-datatable.ps1"
		
		#prep data for bulk import
		$dtable = $table | select Date, Recipient, Inbound, Outbound, InboundSize, OutboundSize | out-datatable
		
		#SQL BulkCopy Insert
		
		$bc = new-object ("System.Data.SqlClient.SqlBulkCopy") $conn
		$bc.DestinationTableName = $tableName
		$out = $bc.WriteToServer($dtable)
		
		[void]$log.appendline((("Imported data into temporary table - $($out) - ")+(get-date)))

		$query = get-content "$scriptRoot\sql_parseinput.sql" | out-string
		$cmd.CommandText = $query
		$out = $cmd.ExecuteNonQuery()
		[void]$log.appendline((("Merged the import data into the report table - Rows: $($out) - ")+(get-date)))
		
		$query = "Delete from "+$tableName
		$cmd.CommandText = $query
		$out = $cmd.ExecuteNonQuery()
		[void]$log.appendline((("Cleaned-up the import table - Rows: $($out) - ")+(get-date)))

		$conn.Close()
	}
} catch { 
	[void]$log.appendline("Error - [uploadReport]")
	[void]$log.appendline($Error)
}


[void]$log.appendline((("[End Batch - ")+(get-date)+("]")))

##format the log into html for easy reading in email
#$emailBody = (((convertto-html -body $log -title "log output") -replace '(?m)\s+$', "`r`n<BR>") | out-string)

#Adding only <BR> HTML Tags for easy reading in email - full HTML not needed for string
$emailBody = ($log.ToString() -replace '(?m)\s+$', "`r`n<BR>")
#Needed to send without using default creditianls of the service or computer running the script
$s = New-Object System.Security.SecureString
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "NT AUTHORITY\ANONYMOUS LOGON", $S


Send-MailMessage -To $emailTo -From $emailFrom -Subject "$($scriptTitle) $($scriptName)" -BodyAsHtml $emailBody -SmtpServer $smtpServer -Credential $creds
writelog

Remove-PSSession $Session


