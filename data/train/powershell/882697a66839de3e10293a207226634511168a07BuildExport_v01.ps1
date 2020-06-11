# This PowerShell script was released under the Ms-PL license (http://www.opensource.org/licenses/ms-pl.html).
# It is maintained and distributed as a CodePlex project at http://dynamicsaxbuild.codeplex.com.

# This script runs compilation, synchronization etc. of a Dynamics AX 2012 environment,
# makes a log and sends results via e-mail.
# It requires DynamicsAxCommunity PowerShell module (see dynamicsaxbuild.codeplex.com).

# Tribridge modified version 
# added process to export the Modelstore
# set the location of the configuration file $axConfigFile
# set export model variables
# run from dynamics AX powershell command 
#

 
Import-Module DynamicsAxCommunity -DisableNameChecking

#region Process definition
$axConfigFile = "e:\devbuild\DEV-VAR.axc"


$restartAos = $true
$runCompilation = $true
$runCompilationToIL = $true
$runSynchronization = $true
$runXref = $False

#set variable for the export of model store
$targetserver = "AJMTESTSQLVM"
$targetdb = "AXDEV"
$modelstorepath = "\\ajmtestdevvm\DynamicsAX\tmp\"

$dte = get-date -format s
$dte = $dte.tostring() -replace "[:\s/]",""
$backFileName = $modelstorepath + $targetdb  + $dte + ".axmodelstore"

$compilationTimeout = (New-TimeSpan -Hours 5).TotalSeconds
$ilCompilationTimeout = (New-TimeSpan -Minutes 30).TotalSeconds
$synchronizationTimeout = (New-TimeSpan -Minutes 30).TotalSeconds
$xrefTimeout = (New-TimeSpan -Hours 6).TotalSeconds
$xrefIndexTimeout = (New-TimeSpan -Minutes 30).TotalSeconds
#endregion

#region E-mail parameters
$sendEmail = $false
$smtpServerName = ''
$emailFrom = ''
$emailTo = ''
#endregion
#region Variables
$startedAt = Get-Date

$logFileName = "build.log"
$logDirBase = (Join-Path $ENV:USERPROFILE "Microsoft\Dynamics Ax\Log")
$compilationLogName = 'AxCompileAll.html'

#Stop when any error occurs
$ErrorActionPreference = "Stop"

#endregion
#region Functions
Function LogMessage
{
	[CmdletBinding()]
	Param(
		[string]$message,
		[switch]$appendTime
	)
	
	if ($appendTime)
	{
		$message = ("[{0:HH:mm:ss}] $message" -f (Get-Date))
	}
	Write-Verbose $message	
	Add-Content $logFile $message	
}
Function SendEmail([string]$subject, [string]$body, [array]$attachments)
{
	$extraParams = @{}
	
	if ((Test-Path $logFile) -and ((Get-Content $logFile) -ne $null))
	{
		$attachments += $global:logFile
	}
	
	if ($attachments)
	{
		$extraParams['Attachments'] = $attachments
	}
	
	Send-MailMessage -From $emailFrom -To $emailTo -Subject $subject -Body $body -SmtpServer $smtpServerName -BodyAsHtml @extraParams
}
#endregion
#region Error handling
trap
{
	LogMessage $_.Exception -appendTime
	
	if ($sendEmail)
	{
		$body = "<html><body>"
		$body += "<h1>Build failed</h1>"
		$body += ("<p>Time: {0:G}</>" -f (Get-Date))
		$body += '<p>Error: ' + $_.Exception.Message + '</p>'
		$body += '<p>Script: {0} (line {1})</p>' -f $_.InvocationInfo.ScriptName, $_.InvocationInfo.ScriptLineNumber
		$body += "</html></body>"
		
		SendEmail "Build failed" $body
	}
}
#endregion
#region Initialization

if (-not $axConfigFile)
{
	throw "No configuration file specified"
}
if (-not (Test-Path -LiteralPath $axConfigFile))
{
	throw "Configuration file $axConfigFile was not found"
}

[string]$logdir = (Join-Path $logDirBase (Get-Date -Format 'yyyy-MM-dd-HH-mm'))
if (-not (Test-Path $logdir))
{
	md $logdir
}
$logFile = (Join-Path $logdir $logFileName)

New-Item $logFile -ItemType file

LogMessage "Dynamics AX 2012 Automated Build`n"

LogMessage ("Run by: " + $env:username)
LogMessage "AX config: $axConfigFile"
LogMessage "==========" 
LogMessage  "export from server: $targetserver "
LogMessage  "export from data base: $targetdb"
LogMessage  " modelstore export path: $modelstorepath"

LogMessage "Started" -AppendTime


#endregion
#region Process
if ($restartAos)
{
	LogMessage "Restarting AOS" -AppendTime
	Restart-AXAOS -ConfigPath $axConfigFile
	LogMessage "AOS restarted" -AppendTime
}
if ($runCompilation)
{
	LogMessage "Compiling application" -AppendTime
	Compile-AXXpp -ConfigPath $axConfigFile -LogPath $logdir -Timeout $compilationTimeout
	$compilationLog = (Join-Path $logdir $compilationLogName)
	$logContent = Get-Content -LiteralPath $compilationLog
	[int]$numOfXppErrors = [Regex]::Match($logContent, '\<H2\>Errors *: (\d*)\</H2\>').Groups[1].Value
	LogMessage "Application compiled ($numOfXppErrors errors)" -AppendTime
}
if ($runCompilationToIL)
{
	LogMessage "Compiling IL" -AppendTime
	Compile-AXIL -ConfigPath $axConfigFile -LogPath $logdir -Timeout $ilCompilationTimeout
	LogMessage "IL compiled" -AppendTime
}
if ($runSynchronization)
{
	LogMessage "Synchronizing database" -AppendTime
	Synchronize-AXDatabase -ConfigPath $axConfigFile -LogPath $logdir -Timeout $synchronizationTimeout
	LogMessage "Database synchronized" -AppendTime
}
if ($runXref)
{
	LogMessage "Updating cross-references" -AppendTime
	Update-AXXRef -ConfigPath $axConfigFile -LogPath $logdir -Timeout $xrefTimeout
	LogMessage "Cross-references updated"
	
	LogMessage "Updating cross-reference indexes" -AppendTime
	Update-AXXRefIndex -ConfigPath $axConfigFile -Timeout $xrefIndexTimeout
	LogMessage "Cross-reference indexes updated" -AppendTime
}
LogMessage "exporting Modelstore to $backFileName " -AppendTime
Export-AXModelStore -Server $targetserver -Database $targetdb -File $backFileName 
LogMessage "export complete" -AppendTime

LogMessage "Finished" -AppendTime
#endregion
#region Send status e-mail
if ($sendEmail)
{
	$body = "<html><body>"
	$body += "<h1>Build succeeded</h1>"
	$body += ("<p>Started: {0:G}</>" -f $startedAt)
	$body += ("<p>Ended: {0:G}</>" -f (Get-Date))
	$body += "</html></body>"

	$compilationLog = (Join-Path $logdir $compilationLogName)
	$attachments = @()
	
	if (Test-Path -LiteralPath $compilationLog)
	{
		$attachments += $compilationLog
	}
	SendEmail "Build succeeded" $body $attachments
}
#endregion