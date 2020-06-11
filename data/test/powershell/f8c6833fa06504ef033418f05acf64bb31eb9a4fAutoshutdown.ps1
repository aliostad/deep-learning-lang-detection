#use no key to chutdown on processor idle
# use key -t and time in minutes to shutdown after time period

param($command, $value)

function Shutdown
{
	shutdown /s /t 0 /f
}

if(($commad -eq "-t") -and ($value -ne $null))
{
	Sleep $value*60
	Shutdown
}

$counter = 10
while($true){
	$obj = Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average
	$val = $obj.Average
	
	if($val -lt 30){
		$counter--
	}
	else
	{
		$counter = 10
	}
	if($counter -eq 0){
		Shutdown
	}
	$out = "CPU load: $val, counter: $counter"
	Write-Output $out
	$out | Out-File "h:\autoshut.log" -Append
	Sleep -Seconds 10
}
