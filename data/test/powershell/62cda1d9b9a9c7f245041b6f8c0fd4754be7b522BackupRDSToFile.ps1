# set "Option Explicit" to catch subtle errors 
set-psdebug -strict

$scriptDirectory = Split-Path $MyInvocation.MyCommand.Path 
$scriptCommonDirectory = Join-Path -Path (Split-Path -parent $scriptDirectory) -ChildPath "Common"
$scriptUtilitiesDirectory = Join-Path -Path (Split-Path -parent $scriptDirectory) -ChildPath "Utilities"
. (Join-Path -Path $scriptCommonDirectory -ChildPath "AwsCommonFunctions.ps1") 
. (Join-Path -Path $scriptCommonDirectory -ChildPath "DBFunctions.ps1") 
. (Join-Path -Path $scriptUtilitiesDirectory -ChildPath "ZipFunctions.ps1") 




#Retrieve data from database and zip the result
function Copy-DatabaseToFile
{
	param (
		[String]
			$serverpath 
		, [String]
			$username
		, [String]
			$password
		, [String]
			$ZipFileName
	)
"Starting $(Get-Date)"
	$sqlServer = Create-ServerConnection -serverName $serverpath -username $username -password $password
	foreach ($database in $databaseList)
	{
		Copy-StructureFromDatabaseToFile -sqlServer $sqlServer -Database $database -FilePath $pathForSaveFiles
		Copy-DataFromDatabaseToFile -sqlServer $sqlServer -Database $database -FilePath $pathForSaveFiles
	}	
"Finished data fetch $(Get-Date)"
	Zip-Files "$($pathForSaveFiles)" "$($pathForSaveFiles)$($ZipFileName).ZIP" "\.SQL"
"Finished $(Get-Date)"
}

[Array] $databaseList = @("ADCommon","AssetsDB")
$pathForSaveFiles = "C:\temp\"
$serverpath = "dd1bqfz7u1mvykn.cjcedzmxrh4x.ap-southeast-2.rds.amazonaws.com"
$username = "masterUserName"
$password = "password"
$bucketName = "assetsdeploy"
$cfStackName = "Test"
$Account = "Dev"
$version = "5.4.1.700"
$datetime = (Get-Date -UFormat "%Y%m%d%H%M")
$ZipFileName = "$($Account)_$($cfStackname)_$($datetime)_$($version)"

Copy-DatabaseToFile -serverpath $serverpath -username $username -password $password -ZipFileName $ZipFileName


