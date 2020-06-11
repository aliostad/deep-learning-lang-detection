param(
	[parameter(Mandatory = $true)][System.String]$LTFolderPath,
	[parameter(Mandatory = $true)][System.String]$SPSiteURL,
	[parameter(Mandatory = $true)][System.String]$SPServerFQDN,
	[parameter(Mandatory = $true)][System.String]$TestUserName,
	[parameter(Mandatory = $true)][System.String]$TestUserPassword
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

$outFileName = "EndpointConfigDone.txt"
$outFilePath = Join-Path $LTFolderPath $outFileName

$configXMLSubPath = "Config\Config.xml"
$configXMLPath = Join-Path $LTFolderPath $configXMLSubPath
if(!(Test-Path $configXMLPath))
{
	LogToFile -Message "ERROR: Config xml file not found at the expected path: $($configXMLPath)"
	throw [System.IO.FileNotFoundException] "Config xml file not found at the expected path: $($configXMLPath)"
}

$usersCSVSubPath = "Config\Users.csv"
$usersCSVPath = Join-Path $LTFolderPath $usersCSVSubPath
if(!(Test-Path $usersCSVPath))
{
	LogToFile -Message "ERROR: Users csv file not found at the expected path: $($usersCSVPath)"
	throw [System.IO.FileNotFoundException] "Users csv file not found at the expected path: $($usersCSVPath)"
}

$loadTestSubPath = "LoadTests\SharePoint2013HomePage.loadtest"
$loadTestPath = Join-Path $LTFolderPath $loadTestSubPath
if(!(Test-Path $loadTestPath))
{
	LogToFile -Message "ERROR: Loadtest file not found at the expected path: $($loadTestPath)"
	throw [System.IO.FileNotFoundException] "Loadtest file not found at the expected path: $($loadTestPath)"
}

#Run the prep only once
if(!(Test-Path $outFilePath))
{
	LogToFile -Message "Preparing load test for run"
	(Get-Content $configXMLPath).replace('%SPROOTURL%',$SPSiteURL) | Set-Content $configXMLPath -Encoding Oem
	(Get-Content $usersCSVPath).replace('%TESTUSER%',$TestUserName) | Set-Content $usersCSVPath -Encoding Oem
	(Get-Content $usersCSVPath).replace('%TESTUSERPASSWORD%',$TestUserPassword) | Set-Content $usersCSVPath -Encoding Oem
	(Get-Content $loadTestPath).replace('%SPSERVERNAME%',$SPServerFQDN) | Set-Content $loadTestPath -Encoding Oem
	
	$outFileName = "EndpointConfigDone.txt"
	$outFilePath = Join-Path $LTFolderPath $outFileName
	New-Item $outFilePath -ItemType File
	LogToFile -Message "Done preparing load test for run"
}
else
{
	LogToFile -Message "Target load test is already prepared to run"
}





