param(
	[parameter(Mandatory = $true)]
	[String]$baseURL,
	[parameter(Mandatory = $true)]
	[Int]$userCount
)

Add-PSSnapin "Microsoft.SharePoint.Powershell"
Import-Module LogToFile

$ltSolPath = "$env:SystemDrive\Program Files\Common Files\microsoft shared\Web Server Extensions\15\LoadGeneration"
# second run of script creates the users and their personal sites
LogToFile -Message "Executing load test init script"
pushd $ltSolPath
.\Initialize-SPFarmLoadTest.ps1 $baseURL $userCount
popd
LogToFile -Message "Done executing load test init script"
