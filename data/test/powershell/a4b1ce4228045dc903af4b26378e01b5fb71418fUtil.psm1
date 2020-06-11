Function Write-LogInfo()
{
<#
    .Synopsis
    Write output to a log file and standard out

    .Description
    Write output to a log file and standard out.  Rotates the log based on given size limit.

    .Parameter logFile
    Path to the log file

    .Parameter logMessage
    The message to log

    .Parameter roateSize
    Start a new log after provided size is reached.

    .Example
    Write-LogInfo -logFile "logs\somelog.log" -logMessage "Test" -rotateSize 1Mb
#>

   Param(
        [Parameter(Mandatory=$True)][string]$logFile,
        [Parameter(Mandatory=$True)][string]$logMessage,
        [Parameter(Mandatory=$False)]$rotateSize = 1Mb
    )
	
	# Rollover logfile if greater than 1MB
	if (Test-Path $logfile)
	{
		if (((Get-Item $logfile).Length / 1Mb) -gt 1) 
        {
			# rename current logfile
			$newname = $logfile + "-" + (Get-Date).Year + "-" + (Get-Date).Month + "-" + (Get-Date).Day + ".archive"
			Move-Item -Path $logfile -Destination $newname
		}
	}
	
  $currentTime = (Get-Date).toString()
  $message = $currentTime
  $message = $message + " :: "
  $message = $message + $logMessage
  $message >> $logFile
  Write-Host -Debug "DEBUG:`t$message"
  
}

Export-ModuleMember Write-LogInfo