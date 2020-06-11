param(
	[parameter(Mandatory = $true)]
	[String]$LoadTestPackageSourcePath,
	[parameter(Mandatory = $true)]
	[String]$LoadTestDestinationPath,
	[parameter(Mandatory = $true)]
	[String]$SharePointServerName,
	[parameter(Mandatory = $true)]
	[String]$SPFarmSQLServerName,
	[parameter(Mandatory = $true)]
	[Int]$NumberOfUsers,
	[parameter(Mandatory = $true)][ValidateSet("CSOMListRW.loadtest","MySiteHostRW.loadtest","MySiteRW.loadtest")]
	[String]$LoadTestToRun,
	[parameter(Mandatory = $true)]
	[String]$AdminUserName,
	[parameter(Mandatory = $true)]
	[String]$AdminPWD,
	[parameter(Mandatory = $true)]
	[int]$VSVersionNumber
)

# Install the log to file module
$currentPath = Convert-Path .
$PSModulePath = "$($env:ProgramFiles)\WindowsPowerShell\Modules"
$LogToFileFolderName = "LogToFile"
$LogToFileFolderPath = Join-Path $PSModulePath $LogToFileFolderName
if(-not(Test-Path $LogToFileFolderPath))
{
	New-Item -Path $LogToFileFolderPath -ItemType directory
	$moduleFileName = "LogToFile.psm1"
	$moduleFilePath = Join-Path $currentPath $moduleFileName
	Copy-Item $moduleFilePath $LogToFileFolderPath
}
Import-Module LogToFile

# Create the log file
CreateLogFile

# Script names
$ltDownloadScript = "DownloadLoadTestPackage.ps1"
$prepLoadTestScript = "TestControllerPrepareLoadTest.ps1"
$startLTRunScript = "TestControllerStartLoadTestRun.ps1"

# Script paths
$ltDownloadScriptPath = Join-Path $currentPath $ltDownloadScript
$prepLoadTestScriptPath = Join-Path $currentPath $prepLoadTestScript
$startLTRunScriptPath = Join-Path $currentPath $startLTRunScript

# Other variables
$loadTestFolderSubPath = "SharePointLoadTest\LoadTests"
$testSettingsFileName = "Remote.testsettings"
$testSettingsFilePath = Join-Path $LoadTestDestinationPath $testSettingsFileName
$ltFolderPath = Join-Path $LoadTestDestinationPath $loadTestFolderSubPath
$ltToRunPath = Join-Path $ltFolderPath $LoadTestToRun

# Invoke lt download script
LogToFile -Message "Starting download load test script"
Invoke-Command -ComputerName localhost -FilePath $ltDownloadScriptPath -ArgumentList $LoadTestPackageSourcePath,$LoadTestDestinationPath
LogToFile -Message "Download load test script done"

# Invoke lt preparation script
LogToFile -Message "Starting load test preparation script"
Invoke-Command -ComputerName localhost -FilePath $prepLoadTestScriptPath -ArgumentList $LoadTestDestinationPath,$SharePointServerName,$SPFarmSQLServerName,$NumberOfUsers,$AdminUserName,$AdminPWD,$VSVersionNumber
LogToFile -Message "Load test preparation script done"

# Invoke run load test script
LogToFile -Message "Starting load test execution script"
Invoke-Command -ComputerName localhost -FilePath $startLTRunScriptPath -ArgumentList $ltToRunPath,$testSettingsFilePath,$VSVersionNumber
LogToFile -Message "Load test execution script done" 
