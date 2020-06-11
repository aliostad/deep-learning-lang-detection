#schedule this script to run every 5 minutes to work with SQL procs and tables
. .\Monitoring-Checks.ps1

function Send-SummaryEmail ([Collections.Generic.List[LogEntry]]$errorMessageCollection)
{
    if($errorMessageCollection.count -gt 0)
    {
        
        $SmtpClient = new-object system.net.mail.smtpClient
        $MailMessage = New-Object system.net.mail.mailmessage
        $SmtpClient.Host = ""
        $mailmessage.from = ("")
        $mailmessage.To.add("")
        $mailmessage.Subject = “PowerShell Monitoring System Alert”
        $body = $errorMessageCollection | % {$_.ErrorMessage + "`r`n"} 
        $mailmessage.Body = $body
        $smtpclient.Send($mailmessage)
    }
}

function Append-ErrorList([LogEntry] $logentry, [Collections.Generic.List[LogEntry]]$errorMessageCollection)
{
    if(-Not([string]::IsNullOrEmpty($logentry.ErrorMessage)))
    {
        $errorMessageCollection.Add($logentry)
    }
}


function Update-Database([LogEntry]$entry)
{
    $sqlConn = New-Object System.Data.SqlClient.SqlConnection
    $sqlConn.ConnectionString = "Data Source=;Initial Catalog=Monitoring;Persist Security Info=True;User ID=;Password="
    $sqlConn.Open()

    $sql = "INSERT INTO LogEntries (TimeStamp, Server, MonitoringType, ErrorMessage, IsHeartbeat) VALUES ('" + $entry.TimeStamp.ToString("yyyy-MM-dd HH:mm:ss:fff") + "', '" + $entry.Server + "', '" + $entry.MonitorType + "', '" + $entry.ErrorMessage + "', '" + $entry.IsHeartbeat + "')"
    $cmd = New-Object System.Data.SqlClient.SqlCommand($sql,$sqlConn)
    $rdr = $cmd.ExecuteNonQuery()
    
    $sqlconn.Close()
    
}


function Run-MonitoringChecks ($LogToDB = 0, $SendEmail = 0)
{
    $messages = New-Object Collections.Generic.List[LogEntry]

    #Run monitoring checks...
    Check-ServerIsOnline google.com | % { Append-ErrorList $_ $messages }
    #TODO: ADD ALL THE FUNCTION CALLS YOU WANT TO RUN HEAR
    #THE FORMAT SHOULD ALWAYS BE LIKE THE LINE ABOVE.
    #FOR EXAMPLE:
    #Check-SOMETHING [thing to check [and parameters]] | % { Append-ErrorList $_ $messages }

    #log to DB
    if($LogToDB -gt 0)
    {
       $messages | % { Update-Database $_ }

       if($messages.Count -eq 0)
       {
            $heartBeat = new-object LogEntry
            $heartBeat.TimeStamp = [DateTime]::Now
            $heartBeat.IsHeartbeat = 1
            Update-Database $heartBeat
       }
    }

    #email error messaging
    if($SendEmail -gt 0)
    {
        Send-SummaryEmail($messages)
    }

} 

function Check-DBOnline([string]$Server)
{
    $logentry = new-object LogEntry
    $logentry = Check-ServerIsOnline $Server

    if($logentry -eq $null)
    {
        Set-Content dbstatus.txt 1
    }
    else
    {
        $status = Get-Content dbstatus.txt
        if($status -eq 1)
        {
            $errorMessageCollection = new-object Collections.Generic.List[LogEntry]
            $errorMessageCollection.Add($logentry)
            Send-SummaryEmail $errorMessageCollection 
            Set-Content dbstatus.txt 0
        }
    }
}


Check-DBOnline [DBNAME]

Run-MonitoringChecks -LogToDB 0 -SendEmail 0

