Write-Debug "Common/Messages loaded"

function Get-StandardResultMessage ($defaultName = "")
{
	return @{
		name = $defaultName
		state = 0
        attempts = 0
		message = @{
			title = $defaultName
			content = "Perfect"
		}
		data = @();
		duration = $null;
	}
}

function Convert-ResultToString($result, $elapsed, $jobsRemaining)
{	
	Write-Debug "Convert-ResultToString"
	$message = "";
	if ($result.duration -ne $null)
	{
		$duration = ConvertDurationToString $result.duration
	}

	if ($jobsRemaining -eq $null)
	{
		$jobsRemaining = "---"
	}
	
	$message = "{4,4} | {0, -73} | {2,8} | {3,11} | [{5}] | {1, -80}"  -f  $result.message.title, $result.message.content, $duration, $elapsed, $jobsRemaining, $result.state, $result.attempts
	 
	return $message;
}

function Print-ResultMessage ($result, $comparisonTime, $jobsRemaining = 0) 
{
	Write-Debug "Print-ResultMessage"
	$duration =  (ConvertDurationToString (Get-Date).Subtract($comparisonTime).TotalSeconds )
	
	$screenOutput = Convert-ResultToString $result $duration $jobsRemaining
	
	if ($result.data.count -gt 0)
	{
		#$result.data | % {$screenOutput += "`n$(Convert-ResultToString $_ $null )"}
	}
	
	$color = "Red";
 
	if ($result.state -eq 1) {
		$color = "Yellow"
		# $screenOutput += "`a"
	}

	if ($result.state -eq 0) {
		$color = "Green"
	}

	if ($result.state -eq 2) {  
		# $screenOutput += "`a`a`a"
		$color = "Red"
	}

	if ($jobsRemaining -eq $null)
	{
		$color = "Cyan"
	}
	
	Write-Host $screenOutput -fore $color
}


function ConvertDurationToString() {
    param ([Double]$totalSeconds)
    
    $display = "["
    if ($totalSeconds -gt 60) {
        $remainingSeconds = $totalSeconds % 60
        $minutes = $totalSeconds - $remainingSeconds
        $display += $minutes / 60
        $display += "m "
        $totalSeconds = $remainingSeconds
    }
    $display += $totalSeconds.ToString("F2")
    $display += "s]"
    return $display 
}
