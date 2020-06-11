<#
        .Name
		 Execute-LicenseManager.ps1
        .DESCRIPTION
         Executes a MicroStrategy License Manager command line statement with a Powershell wrapper.
        .PARAMETER ProjectSourceName 
		 The name of the MicroStrategy project source used to connect to the i-server
		.PARAMETER UserName 
		 The MicroStrategy user name used to connect to the i-server 
		.PARAMETER UserGroupToAudit 
		 The MicroStrategy user group to audit, the default is the "Everyone" group 
		.PARAMETER ReportFile  
		 The HTML report file, the default is "AuditingReport.htm"
        .PARAMETER LogFile
		 The MicroStrategy License Manager log file, the default is "LicMgr.log"
		.PARAMETER ShowOutput
         A switch to turn on the display of the output in the console
        .PARAMETER ShowPrivilege
		 A switch to turn on the display of the privileges in the report
        .PARAMETER ShowLdapUsers 
		 A switch to turn on the display of the LDAP users
		.PARAMETER SmtpServer 
		 The SmtpServer used to send out email after script completion
        .PARAMETER From 
		 The From email address used to send out an email after script completion
        .PARAMETER To
		 The To email address used to send out an email after script completion
	    .PARAMETER JobName
		 The job name 
		.PARAMETER JobFunction
		 Explains what this script does
		.PARAMETER ScriptLog
         The log file for this script		

        .NOTES
         AUTHOR....:  Craig Grady
         LAST EDIT.:  08/22/2014
         CREATED...:  08/14/2014
#>

[CmdletBinding()]
param(
[Parameter(Mandatory=$true)]
[string]$ProjectSourceName, 
[Parameter(Mandatory=$true)]
[string]$UserName, 
[Parameter(Mandatory=$true)]
[string]$Password,
[string]$UserGroupToAudit, 
[string]$ReportFile = "AuditingReport.htm",
[string]$LogFile,
[switch]$ShowOutput = $false, 
[switch]$ShowPrivilege = $false, 
[switch]$ShowLdapUsers = $false,
[string]$SmtpServer = "SMTP SERVER NAME",
[string]$From,
[string]$To, 
[string]$JobName = "LicenseMgr",
[string]$JobFunction = "Executes a MicroStrategy License Manager command line statement with a Powershell wrapper.",
[string]$ScriptLog
)

$ScriptStartTime = Get-Date
$nl = [Environment]::NewLine

$cmd = "malicmgr -audit -n $ProjectSourceName -u $UserName -p $Password "
if($UserGroupToAudit) { $cmd += "-g $UserGroupToAudit " }
if($ReportFile) { $cmd += "-o $ReportFile " }
if($LogFile) { $cmd += "-l $LogFile " }
if($ShowOutput) { $cmd += "-showouput "}
if($ShowPrivilege) { $cmd += "-showprivilege " }
if($ShowLdapUsers) { $cmd += "-showldapusers " }

CMD /C $cmd

sleep 5

foreach( $browser in (New-Object -ComObject Shell.Application).Windows()) {
   if($browser.LocationName -eq "AuditingReport.htm")  { 
       $browser.Quit() 
     }
}

[xml]$audit = Get-Content (((Get-ChildItem $ReportFile).Fullname).Split(".")[0] + ".xml")
$Status = if($audit.MicrostrategyLicenseManagerReport.Auditing.AuditDetailsToShow -eq "True") { "Success"} else {"Failure"}
$audit = $null

$ScriptEndTime = Get-Date
$ScriptDuration = New-TimeSpan -End $ScriptEndTime -Start $ScriptStartTime
$ProcessingTime = $null
if( $ScriptDuration.Hours -gt 0) { $ProcessingTime += $ScriptDuration.Hours.ToString() + " Hours, " } 
if( $ScriptDuration.Minutes -gt 0) { $ProcessingTime += $ScriptDuration.Minutes.ToString() + " Minutes, " } 
$ProcessingTime += $ScriptDuration.Seconds.ToString() + " Seconds" 
  
  
$Subject = $JobName + ": " + $Status
$Message = $Subject + $nl + 
        "Server: " + $env:ComputerName + "   " + $nl + 
        "Script Execution Start time: " +  $ScriptStartTime + "   " + $nl +
        "Script Execution End time: " +  $ScriptEndTime + "   " + $nl +
        "Script Duration: " + $ProcessingTime + "   " 
		
$Body = $JobFunction + $nl + $nl + $Message
		
Out-File -FilePath $ScriptLog -InputObject $Message

Send-MailMessage -To $To -Subject $Subject -From $From -SmtpServer $SmtpServer -Body $Body 		