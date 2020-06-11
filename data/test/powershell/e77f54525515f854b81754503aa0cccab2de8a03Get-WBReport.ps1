#Requires –Version 3
#Requires –Modules WindowsServerBackup

<#
    PowerShell Windows Server Backup Report
    Twitter: @GavinEke
    
    Requires Windows Server Backup Command Line Tools
    This version is for Windows Server 2012+
    Example usage: .\Get-WBReport.ps1
#>

# Public Varibles
$MailMessageTo = "test@example.com" # List of users to email your report to (separate by comma)
$MailMessageFrom = "test@example.com" # Enter the email you would like the report sent from
$MailMessageSMTPServer = "mail.example.com" # Enter your own SMTP server DNS name / IP address here
$MailMessagePriority = "Normal" # Low/Normal/High
$HTMLMessageSubject = $env:computername+": Backup Report - "+(Get-Date) # Email Subject

# DO NOT CHANGE ANYTHING PAST THIS LINE!

# Private Variables
$WBJob = Get-WBJob -Previous 1
$WBSummary = Get-WBSummary
$WBJobStartTime = $WBJob.StartTime
$WBJobEndTime = $WBJob.EndTime
$WBJobSuccessLog = Get-Content -Path $WBJob.SuccessLogPath
$WBJobFailureLog = Get-Content -Path $WBJob.FailureLogPath

# Change Result of 0 to Success in green text and any other result as Failure in red text
If ($WBSummary.LastBackupResultHR -eq 0) {
    $WBJobResult = "successful"
    $WBJobLog = $WBJobSuccessLog
} Else {
    $WBJobResult = "failed"
    $WBJobLog = $WBJobFailureLog
}

# Assemble the HTML Report
$HTMLMessage = @"
<!DOCTYPE html>
<html>
<head>
<title>$HTMLMessageSubject</title>
<style>
h1.successful {color:green;}
h1.failed {color:red;}
</style>
</head>
<body>
<h1 class="$WBJobResult">Backup $WBJobResult</h1>
Start: $WBJobStartTime<br>
Finished: $WBJobEndTime<br>
<br>
<p>Log:</p>
<br>
$WBJobLog
</body>
</html>
"@

# Email the report
$MailMessageOptions = @{
    From            = "$MailMessageFrom"
    To              = "$MailMessageTo"
    Subject         = "$HTMLMessageSubject"
    BodyAsHTML      = $True
    Body            = "$HTMLMessage"
    Priority        = "$MailMessagePriority"
    SmtpServer      = "$MailMessageSMTPServer"
}
Send-MailMessage @MailMessageOptions
