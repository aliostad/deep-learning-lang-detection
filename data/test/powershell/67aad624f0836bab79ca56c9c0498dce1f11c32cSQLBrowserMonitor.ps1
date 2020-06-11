$date = (get-date).Addminutes(-5)
$rundate = get-date -format 'yyyyMMdd hh:mm:ss'
$DayofWeek = ( get-date ).DayOfWeek.value__
$process = "SQLBrowser"
$Level = "Error"
$Logfile = "F:\DMS\logging\SQLBrowserMonitorLog.log"
#Logic to email or send text based on day of week. eg. weekends send text.
if($DayofWeek -gt 5){
    $Recipient = ""
}
else{
    $Recipient = "jshurak@revspringinc.com"
}

$errors = get-eventlog application -after $date | where-object {$_.Source -eq $process -and $_.EntryType -eq $Level} 


if($errors.count -gt 2){
	stop-service "SQLBrowser"
	start-service "SQLBrowser"	
	$Service = get-service "SQLBrowser"
    if($Service -eq $NULL){
        $Message = "Browser Restart Failed!"
        $LogMessage = $rundate + ": " + $Message
    }
    Else{
        $Message = "Service is now " + $Service.Status    
        $LogMessage = $rundate + ": " + $Message
    }

	send-Mailmessage -To $Recipient -Subject "SQLBrowser restarted on " -From "" -Body $Message -SmtpServer ""
    $LogMessage | Out-File -Append $Logfile
}
else {
    $Message = "No Errors"
    $LogMessage = $rundate + ": " + $Message
    $LogMessage | Out-File -Append $Logfile
}
