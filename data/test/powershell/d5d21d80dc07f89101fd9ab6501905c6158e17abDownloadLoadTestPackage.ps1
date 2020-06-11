param(
	[parameter(Mandatory = $true)][System.String]$LoadTestPackageSourcePath,
	[parameter(Mandatory = $true)][System.String]$LoadTestDestinationPath
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

function Get-LoadTestZip
{
	param(
		[parameter(Mandatory = $true)][System.String] $SourcePath,
		[parameter(Mandatory = $true)][System.String] $TargetPath
	)
	
	if(-not(Test-Path $TargetPath))
	{
		New-Item $TargetPath -ItemType directory
	}
	$destFileName = Split-Path $SourcePath -Leaf
	$destFullPath = Join-Path $TargetPath $destFileName
	
	if(-not(Test-Path $destFileName))
	{
		$wc = New-Object System.Net.WebClient
    	$wc.DownloadFile($SourcePath, $destFullPath)
	}
}

function Expand-ZipFile
{
	param(
		[parameter(Mandatory = $true)][System.String] $SourceZip,
		[parameter(Mandatory = $true)][System.String] $TargetPath
	)
	if(-not(Test-Path $SourceZip))
	{
		throw [System.IO.FileNotFoundException] "$($SourceZip) not found"
	}
	if(-not(Test-Path $TargetPath))
	{
		New-Item $TargetPath -ItemType directory
		Add-Type -assembly “System.IO.Compression.Filesystem”
		[System.IO.Compression.ZipFile]::ExtractToDirectory($SourceZip,$TargetPath)
	}	
}

$ltArchiveFolderName = "LoadTestPackages"
$ltArchivePath = Join-Path $env:SystemDrive $ltArchiveFolderName

if(-not(Test-Path $ltArchivePath))
{
	New-Item $ltArchivePath -ItemType directory	
}
LogToFile -Message "Downloading load test package from $($LoadTestPackageSourcePath) to $($ltArchivePath)"
Get-LoadTestZip -SourcePath $LoadTestPackageSourcePath -TargetPath $ltArchivePath
LogToFile -Message "Done downloading load test package"
$ltZipFileName = Split-Path $LoadTestPackageSourcePath -Leaf
$ltZipLocalPath = Join-Path $ltArchivePath $ltZipFileName
LogToFile -Message "Extracting load test package to $($LoadTestDestinationPath)"
Expand-ZipFile -SourceZip $ltZipLocalPath -TargetPath $LoadTestDestinationPath
LogToFile -Message "Done extracting load test package"
