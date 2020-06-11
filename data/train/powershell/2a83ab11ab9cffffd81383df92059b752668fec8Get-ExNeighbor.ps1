function Get-ExNeighbor {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            Parses "show neighbor" output.
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ShowSupportOutput
	)
	
	$VerbosePrefix = "Get-ExNeighbor:"
	
	$IpRx         = [regex] "(\d+\.){3}\d+"
	$PromptString = [regex] "^.+?->"
	$StartString  = [regex] "$PromptString\ show\ neighbors"
	
	$TotalLines = $ShowSupportOutput.Count
	$i          = 0 
	$StopWatch  = [System.Diagnostics.Stopwatch]::StartNew() # used by Write-Progress so it doesn't slow the whole function down
	
	$ReturnObject = @()
	
	:fileloop foreach ($line in $ShowSupportOutput) {
		$i++
		
		# Write progress bar, we're only updating every 1000ms, if we do it every line it takes forever
		
		if ($StopWatch.Elapsed.TotalMilliseconds -ge 1000) {
			$PercentComplete = [math]::truncate($i / $TotalLines * 100)
	        Write-Progress -Activity "Reading Support Output" -Status "$PercentComplete% $i/$TotalLines" -PercentComplete $PercentComplete
	        $StopWatch.Reset()
			$StopWatch.Start()
		}
		
		if ($line -eq "") { continue }
		
		###########################################################################################
		# Check for the Start/Stop
		
		$Regex = $StartString
		$Match = HelperEvalRegex $Regex $line
		if ($Match) {
			$InSection = $true
			continue
		}
		
		$Regex = $PromptString
		$Match = HelperEvalRegex $Regex $line
		if ($Match) { $InSection = $false }
		
		if ($InSection) {
			$Regex = [regex] "^(?<localport>\w+\.\d+\.\d+)\ +(?<deviceid>[^\ ]+?)\ +(?<remoteport>[^\ ]+?)\ +(?<type>\w+)\ +(?<ip>$IpRx)?"
			$Match = HelperEvalRegex $Regex $line
			if ($Match) {
				$NewObject             = New-Object -Type ExtremeShell.Neighbor
				$NewObject.LocalPort   = $Match.Groups['localport'].Value
				$NewObject.DeviceId    = $Match.Groups['deviceid'].Value
				$NewObject.RemotePort  = $Match.Groups['remoteport'].Value
				$NewObject.Type        = $Match.Groups['type'].Value
				$NewObject.IpAddress   = $Match.Groups['ip'].Value
				$ReturnObject         += $NewObject
			}
		}
	}	
	return $ReturnObject
}