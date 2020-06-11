$here = (Split-Path -parent $MyInvocation.MyCommand.Definition)
import-module -name ($here + "\PsGetKit\PsGetKit.psm1") -force
$UserModulePath = $Env:PSModulePath -split ";" | Select -Index 0

function Assert-Equals ($Actual, $Expected) {
    if ($Actual -ne $Expected){
		Write-Host "Actual $Actual is not equal to expected $Expected" -Fore Red
	}	
}
function Assert-NotNull ($Actual) {
    if ($Actual -eq $null){
		Write-Host "Actual is null" -Fore Red
	}	
}

Write-Host Should support something simple
Submit-Module -GitHubURL: "https://github.com/chaliy/psurl" -ApiUrl: "http://localhost:48060/api" -Verbose