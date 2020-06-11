#requires –version 2.0

Function Show-ScriptStatus-StartInfo {
	Param (
		[parameter(Mandatory=$true)][string]$StartTimeF
	)
	Write-Host 'STARTING: ' -ForegroundColor Green -NoNewline
	Write-Host "$StartTimeFormatted"
	Write-Host ''
}

Function Show-ScriptStatus-QueuingJobs {
	Write-Host "`r".padright(40,' ') -NoNewline
	Write-Host "`rQUEUING JOBS" -ForegroundColor Yellow
	Write-Host ''
}

Function Show-ScriptStatus-JobsQueued {
	Param (
		[parameter(Mandatory=$true)][int]$jobcount
	)
		Write-Host "`r".padright(40,' ') -NoNewline
	If ($jobcount -eq 1) {
		Write-Host "`r1 JOB QUEUED" -ForegroundColor Green
		Write-Host ''
	}
	Else {
		Write-Host "`r$jobcount JOBS QUEUED" -ForegroundColor Green
		Write-Host ''
	}
	Sleep -Seconds 1
}

Function Show-ScriptStatus-JobMonitoring {
	Param (
		[parameter(Mandatory=$true)][string]$hostmethod
	)
	If ($hostmethod -eq 'ComputerName') {
			Write-Host "`r".padright(40,' ') -NoNewline
			Write-Host "`rMONITORING JOB FOR ($ComputerName)" -ForegroundColor Yellow
		}
	If ($hostmethod -eq 'FileName') {
		Write-Host "`r".padright(40,' ') -NoNewline
		Write-Host "`rMONITORING JOBS LEFT FOR ($FileName)" -ForegroundColor Yellow
	}
		Write-Host ''
}

Function Show-ScriptStatus-JobLoopTimeout {
	Write-Host ''
	Write-Host '--------------------' -ForegroundColor Red
	Write-Host '| JOB LOOP TIMEOUT |' -ForegroundColor Red
	Write-Host '--------------------' -ForegroundColor Red
	Write-Host ''
}

Function Show-ScriptStatus-RuntimeTotals {
	Param (
		[parameter(Mandatory=$true)][string]$StartTimeF,
		[parameter(Mandatory=$true)][string]$EndTimeF,
		[parameter(Mandatory=$true)]$RunTime
	)
	Write-Host 'STARTED: ' -ForegroundColor Green -NoNewline
	Write-Host $StartTimeF
	Write-Host 'ENDED:   ' -ForegroundColor Red -NoNewline
	Write-Host $EndTimeF
	Write-Host 'ELAPSED: ' -ForegroundColor Yellow -NoNewline
	Write-Host $RunTime

}

Function Show-ScriptStatus-TotalHosts {
	Param (
		[parameter(Mandatory=$true)][int]$TotalHosts
	)
	Write-Host ''
	Write-Host 'TOTAL HOSTS:   ' -ForegroundColor Green -NoNewline
	Write-Host $TotalHosts
	
}

Function Show-ScriptStatus-Files {
	Param (
		[parameter(Mandatory=$true)][string]$ResultsPath,
		[parameter(Mandatory=$true)][string]$ResultsFileName,
		[parameter(Mandatory=$true)][string]$LogPath
	)
	Write-Host ''
	Write-Host 'Results Path:     '  -ForegroundColor Green -NoNewline
	Write-Host "$ResultsPath"
	Write-Host 'Results FileName: '  -ForegroundColor Green -NoNewline
	Write-Host "$ResultsFileName"
	Write-Host 'Log Path:         '  -ForegroundColor Green -NoNewline
	Write-Host "$LogPath"
}

## FAILED TOTALS TALLY
#Write-Host 'TOTAL FAILED:  ' -ForegroundColor Red -NoNewline
#Write-Host $totalfailed
#
#Write-Host '__________________'
#If ((Test-Path -Path $completesuccesslog) -eq $true) {
#	$totalsuccess = (Get-Content -Path $completesuccesslog).Count
#	If ($totalsuccess -eq $null) {
#		$totalsuccess = 1
#	}
#	Write-Host 'TOTAL SUCCESS: ' -ForegroundColor Green -NoNewline
#	Write-Host $totalsuccess
#}

Function Show-ScriptStatus-Completed {
	Write-Host ''
	Write-Host '-------------' -ForegroundColor Green
	Write-Host '| COMPLETED |' -ForegroundColor Green
	Write-Host '-------------' -ForegroundColor Green
	Write-Host ''
}

#region Notes

<# Header
	VERSION: 	1.0.3
	TITLE:		Display Script Status
	PURPOSE:	Multiple Functions for displaying a script status to the host Powershell console
	AUTHOR:		Levon Becker
	NOTES:		Used in several of my scripts
#>


<# Change Log
	1.0.0 - 04/06/2011
		Created
	1.0.1 - 02/03/2012
		Updated Info section
		Removed Nonewline at end of Jobs Queued
	1.0.2 - 02/07/2012
		Added manditory and set as int for Show-ScriptStatus-JobsQueued parameter
#>

#endregion Notes
