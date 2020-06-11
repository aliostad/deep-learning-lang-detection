# sh.rcapi\api\logger.ps1 - Powershell
#
# Logger library
#
# Author: Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

Function Logger ($logLevel, $message) {
	$date = Get-Date -UFormat %Y-%m-%d;
	$time = Get-Date -UFormat %H:%M:%S;
	$message = "[$date $time] $message";

	If ($logToScreen) {
		Write-Host $message;
	}

	If ($logToFile) {
		$message | Out-File $logFile -Append;
	}
}

Function LogError ($message) {
	Logger 'error' $message;
}
Function LogInfo ($message) {
	Logger 'info' $message;
}

Function GetLogFilePath($function) {
	If ( -Not (Test-Path $logPath)) {
		Throw "Log path does not exist: $logPath";
	}

	If ($function) {
		$fileName = $function;
	}
	Else {
		$fileName = "sh.rcapi";
	}
	$date = Get-Date -UFormat %Y-%m-%d;
	$time = Get-Date -UFormat %H:%M:%S;
	$logFile = "$logPath" + "$fileName" + "-$date" + '.log';

	Return $logFile;
}
