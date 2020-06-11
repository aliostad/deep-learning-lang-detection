param(
	[parameter(Mandatory = $true)][System.String]$LoadTestPackageSourcePath,
	[parameter(Mandatory = $true)][System.String]$LoadTestDestinationPath,
	[parameter(Mandatory = $true)][System.String]$SPSiteURL,
	[parameter(Mandatory = $true)][System.String]$SPServer,
	[parameter(Mandatory = $true)][System.String]$TestUserName,
	[parameter(Mandatory = $true)][System.String]$TestUserPassword,
	[parameter(Mandatory = $true)][System.String]$TestControllerName
)

function LogToFile
{
   param (
		[parameter(Mandatory = $true)][System.String]$Message,
		[System.String]$LogFilePath = "$env:SystemDrive\CustomScriptExtensionLogs\CustomScriptExtension.log"
   )
   $timestamp = Get-Date -Format s
   $logLine = "[$($timestamp)] $($Message)"
   Add-Content $LogFilePath -value $logLine
}

# Create log file
$logFolderName = "CustomScriptExtensionLogs"
$logFolderPath = Join-Path $env:SystemDrive $logFolderName
if(!(Test-Path $logFolderPath))
{
	New-Item $logFolderPath -ItemType directory	
}
$logFileName = "CustomScriptExtension.log"
$logFilePath = Join-Path $logFolderPath $logFileName
if(!(Test-Path $logFilePath))
{
	New-Item $logFilePath -ItemType file	
}

# Script names
$ltDownloadScript = "DownloadLoadTestPackage.ps1"
$ltPrepareScript = "PrepareSampleLTForRun.ps1"
$ltRunScript = "StartLoadTestRun.ps1"
# Paths
$currentPath = Convert-Path .
$ltDownloadScriptPath = Join-Path $currentPath $ltDownloadScript
$ltPrepareScriptPath = Join-Path $currentPath $ltPrepareScript
$ltRunScriptPath = Join-Path $currentPath $ltRunScript

# Invoke lt download script
LogToFile -Message "Starting download load test script"
Invoke-Command -ComputerName localhost -FilePath $ltDownloadScriptPath -ArgumentList $LoadTestPackageSourcePath,$LoadTestDestinationPath
LogToFile -Message "Download load test script done"

$Domain = (Get-WmiObject Win32_ComputerSystem).Domain
$SPServerFQDN = "$($SPServer).$($Domain)"
# Invoke lt prep script
LogToFile -Message "Starting load test preparation script"
Invoke-Command -ComputerName localhost -FilePath $ltPrepareScriptPath -ArgumentList $LoadTestDestinationPath,$SPSiteURL,$SPServerFQDN,$TestUserName,$TestUserPassword
LogToFile -Message "Load test preparation script done"

# Invoke lt run script
$ltSubPath = "LoadTests\SharePoint2013HomePage.loadtest"
$ltPath = Join-Path $LoadTestDestinationPath $ltSubPath
LogToFile -Message "Starting load test execution script"
Invoke-Command -ComputerName localhost -FilePath $ltRunScriptPath -ArgumentList $ltPath,$TestControllerName
LogToFile -Message "Load test execution script done"