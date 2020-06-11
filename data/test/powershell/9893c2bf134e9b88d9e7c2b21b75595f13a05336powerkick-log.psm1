$local:logFileNames = @{
	logName = "$(pwd)\log.txt";
	transcriptLogName = "$(pwd)\log-transcript.txt";
};

function Get-Log {	
	[string] $loggerName = ((Get-PSCallStack)[1].Command)	
	if($loggerName -match '<position>'){
		$loggerName = $Env:COMPUTERNAME
	}
	
	New-Object psobject |
		Add-Member -Name "Info" -MemberType ScriptMethod {
			param([string] $message)
			Log $message "Info" $this.Name			
		} -PassThru |
		Add-Member -Name "Debug" -MemberType ScriptMethod {
			param([string] $message)
			Log $message "Debug" $this.Name	-ForegroundColor DarkGray				
		} -PassThru |		
		Add-Member -Name "Warning" -MemberType ScriptMethod {
			param([string] $message)
			Log $message "Warning" $this.Name -ForegroundColor Yellow
		} -PassThru |		
		Add-Member -Name "Error" -MemberType ScriptMethod {
			param([string] $message)
			Log $message "Error" $this.Name	-ForegroundColor Red		
		} -PassThru |		
		Add-Member -Name "Name" -MemberType NoteProperty -Value $loggerName -PassThru
}

function Log-ToFile {
	param([string]$message)
	$logFileName = $logFileNames.logName;
	if(!(Test-Path $logFileName -PathType Leaf)){
		[void](New-Item $logFileName -ItemType file -WhatIf:$false)
	}
	Add-Content -Value $message -Path $logFileName -WhatIf:$false
}

function Add-ContentToLogFile {
	param($lines)
	$lines | %{ Add-Content -Value $_ -Path $logFileNames.logName -WhatIf:$false }
}

function Log {
	[CmdLetBinding()]
	param([string]$message, [string]$severity, [string]$logger,[consolecolor]$ForegroundColor=(Get-Host).UI.RawUI.ForegroundColor)
	Write-Host ("{0} - [{1}] - {2}" -f $severity, $logger, $message) -ForegroundColor $ForegroundColor
	Log-ToFile ("{0} - $severity - [$logger] - {1}" -f (Get-Date),$message)		
}

function Set-LogFileNameFromCurrentTime {
	[CmdLetBinding()]
	param([string]$logDirectory)
	$dateTime = [System.DateTime]::Now.ToString("yyyy-MM-dd HH.mm.ss")
	$machineName = $Env:COMPUTERNAME
	$baseName = "({0} {1})" -f $machineName, $dateTime
	$logName = "powerkick-log {0}.txt" -f $baseName
	$transcriptName = "powerkick-log-transcript {0}.txt" -f $baseName
	Set-LogFilesNames $logDirectory $logName $transcriptName
}

function Set-LogFileName {
	[CmdLetBinding()]	
	param([string]$logName)
	Set-LogFilesNames (pwd) $logName $logName 
}

function Set-LogFilesNames {
	[CmdLetBinding()]
	param([string]$logDirectory = '.',[string]$logName,[string]$transcriptName)
	$logFileNames.logName = (Join-Path $logDirectory $logName)	
	$logFileNames.transcriptLogName = (Join-Path $logDirectory $transcriptName)	
}



function Get-TranscriptLogFile {
	$logFileNames.transcriptLogName 
}

function Get-LogFile {
	$logFileNames.logName
}

Export-ModuleMember -Function Get-Log, Set-LogFileNameFromCurrentTime, Get-TranscriptLogFile, Get-LogFile, Set-LogFileName, Add-ContentToLogFile
