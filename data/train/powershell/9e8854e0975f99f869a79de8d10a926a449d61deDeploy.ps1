
# These variables should be set via the Octopus web portal:
#
#   ConnectionString         - The .Net connection string for the DB
if (! $ConnectionString)
{
	Write-Host "Missing required variable ConnectionString" -ForegroundColor Yellow
	exit 1
}

# Default SkipDataLoad Variable to False
if (!$SkipDataLoad)
{
	$SkipDataLoad = $false
}

# Internal Variables
$contentPath  = (Join-Path $OctopusOriginalPackageDirectoryPath "content")
$dbFileName = (Get-ChildItem $contentPath\*.dacpac -Name | Select-Object -First 1)
$dbFilePath = (Join-Path $contentPath $dbFileName)

$publishSettingsPath = (Join-Path $contentPath "DeploySettings.publish.xml")

$sqlPackageDir = "${Env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin"
$sqlPackageExe = (Join-Path $sqlPackageDir "SqlPackage.exe")

$dataLoaderPath = (Join-Path $OctopusOriginalPackageDirectoryPath "tools")
$dataLoaderExe = (Join-Path $dataLoaderPath "DatabaseDataLoader.exe")

# Write all variables to build
Write-Host "Db File Path:" $dbFilePath
Write-Host "Sql Exe File Path:" $sqlPackageExe
Write-Host "Data Loader Path:" $dataLoaderExe

# Run the deployment tool
Set-Location $sqlPackageDir
& $sqlPackageExe /Action:Publish /SourceFile:"$dbFilePath" /TargetConnectionString:"$ConnectionString" /Profile:"$publishSettingsPath" | Write-Host

# Manual skip of data load
if ($SkipDataLoad -eq $true)
{
	Write-Host "Data Load manually skipped"
	Exit 0
}

# Run the data load utility
$baseDataPath = (Join-Path $contentPath "Data")
$commonDataPath = (Join-Path $baseDataPath "base")

if (!(Test-Path $baseDataPath))
{
	Write-Host "No Data Directory Exists"
	Exit 0
}

Write-Host "Loading Common Data... Path:" $commonDataPath
& $dataLoaderExe -baseDir:"$commonDataPath" "-connection:$ConnectionString" | Write-Host

$envDataPath = (Join-Path $baseDataPath $OctopusEnvironmentName)

if (Test-Path $envDataPath)
{
	Write-Host "Loading Environment Data... Path:" $commonDataPath
	& $dataLoaderExe -baseDir:"$envDataPath" "-connection:$ConnectionString" | Write-Host
}