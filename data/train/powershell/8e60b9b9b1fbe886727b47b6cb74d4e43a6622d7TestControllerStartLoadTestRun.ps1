param(
	[parameter(Mandatory = $true)]
	[String]$LoadTestPath,
	[parameter(Mandatory = $true)]
	[String]$TestSettingsPath,
	[parameter(Mandatory = $true)]
	[int]$VSVersionNumber
)
Import-Module LogToFile

# Check if the given load test file exists
if(-not(Test-Path $LoadTestPath))
{
	LogToFile -Message "ERROR:$($LoadTestPath) not found"
	throw [System.IO.FileNotFoundException] "$($LoadTestPath) not found"
}

# Check if the given test settings file exists
if(-not(Test-Path $TestSettingsPath))
{
	LogToFile -Message "ERROR:$($TestSettingsPath) not found"
	throw [System.IO.FileNotFoundException] "$($TestSettingsPath) not found"
}

# Prepare the name load test results location
$testResultsFolder = "LoadTestResults"
$testResultsPath = Join-Path $env:SystemDrive $testResultsFolder
if(-not(Test-Path $testResultsPath))
{
	New-Item $testResultsPath -ItemType directory
}

# Create the run results file name
$resultsFileNamePostfix = Get-Date -Format FileDateTime
$resultsFileName = "RunResults$($resultsFileNamePostfix).trx"
$resultsFilePath = Join-Path $testResultsPath $resultsFileName

$VSKeyName = "VS$($VSVersionNumber)0COMNTOOLS"
$CommonToolsPath = (Get-ChildItem Env:$VSKeyName).Value
$CommonSevenPath = Split-Path $CommonToolsPath -Parent
$MSTestSubPath = "IDE\MSTest.exe"
$MSTestPath = Join-Path $CommonSevenPath $MSTestSubPath
$ltargs =  "/testcontainer:$($LoadTestPath) /testsettings:$($TestSettingsPath) /resultsfile:$($resultsFilePath)"

# Start the run
LogToFile -Message "Starting load test run"
$process = [System.Diagnostics.Process]::Start("$MSTestPath", $ltargs )
$process.WaitForExit()
LogToFile -Message "Load test run done, test results file for the run is available at $($resultsFilePath)"