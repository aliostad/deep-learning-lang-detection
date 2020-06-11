param(
	[parameter(Mandatory = $true)]
	[String]$LoadTestPackageSourcePath,
	[parameter(Mandatory = $true)]
	[String]$LoadTestDestinationPath
)

function DownloadLoadTestZip
{
	param(
		[parameter(Mandatory = $true)]
		[String] $SourcePath,
		[parameter(Mandatory = $true)]
		[String] $TargetPath
	)
	
	if(-not(Test-Path $TargetPath))
	{
		New-Item $TargetPath -ItemType directory
	}
	$destFileName = Split-Path $SourcePath -Leaf
	$destFullPath = Join-Path $TargetPath $destFileName
	
	if(-not(Test-Path $destFileName))
	{
		$success = $false
		$retryCount = 0
		while(-not($success))
		{
			try
			{
				$wc = New-Object System.Net.WebClient
    			$wc.DownloadFile($SourcePath, $destFullPath)
				$success = $true
			}
			catch
			{
				$retryCount++
				$success = $false
			}
			if($retryCount -ge 5)
			{
				throw [System.Exception] "Download load test file failed"
			}
		}
		
	}
}

function ExtractZipFile
{
	param(
		[parameter(Mandatory = $true)]
		[String] $SourceZip,
		[parameter(Mandatory = $true)]
		[String] $TargetPath
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
	Remove-Item $SourceZip
}
#Import log to file module
Import-Module LogToFile

$ltArchiveFolderName = "LoadTestPackages"
$ltArchivePath = Join-Path $env:tmp $ltArchiveFolderName

if(-not(Test-Path $ltArchivePath))
{
	New-Item $ltArchivePath -ItemType directory	
}
LogToFile -Message "Downloading load test package from $($LoadTestPackageSourcePath) to $($ltArchivePath)"
DownloadLoadTestZip -SourcePath $LoadTestPackageSourcePath -TargetPath $ltArchivePath
LogToFile -Message "Done downloading load test package"
$ltZipFileName = Split-Path $LoadTestPackageSourcePath -Leaf
$ltZipLocalPath = Join-Path $ltArchivePath $ltZipFileName
LogToFile -Message "Extracting load test package to $($LoadTestDestinationPath)"
ExtractZipFile -SourceZip $ltZipLocalPath -TargetPath $LoadTestDestinationPath
LogToFile -Message "Done extracting load test package"
