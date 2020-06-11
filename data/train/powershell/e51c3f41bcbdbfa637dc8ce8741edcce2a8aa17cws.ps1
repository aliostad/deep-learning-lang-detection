# sh.rcapi\api\functions\process\ws.ps1 - Powershell
#
# Get Working Set of given process
#
# Author:  Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logToScreen = $False;
$logToFile = $False;

Function ModuleMain($processName) {
	Try {
		If ( -Not ($processName)) {
			Throw "Required parameter processName not given";
		}

		$processMeasure = Get-Process |
			Where-Object { $_.ProcessName -eq $processName } |
			Measure-Object WS -Sum;

		$sum = $processMeasure.Sum;


		Return $sum;
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
