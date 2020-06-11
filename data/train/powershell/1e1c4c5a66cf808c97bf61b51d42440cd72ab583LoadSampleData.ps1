Param
(
    [string]$ApiUri = "http://66.150.174.242/ServerTrack/api/AddPerfDataItem"
)

Function LoadPastHourSampleData($span)
{
	$now = [System.DateTime]::Now
	ForEach($i in 0..$span.TotalSeconds)
	{
	   $body = @{
			ServerName = $env:COMPUTERNAME
			CPULoad = Get-Random -Minimum 1 -Maximum 100 # Just simulating the CPU and RAM load to save time in loading sample data
			RAMLoad = Get-Random -Minimum 1 -Maximum 100
			RecordedDateTime = $now.AddSeconds(-$i)
		}

		$result = Invoke-RestMethod -Method Post -Uri $ApiUri -Body $body

		Write-Host $result
	}
}

Function LoadPastDaySampleData($span)
{
	$now = [System.DateTime]::Now
	ForEach($i in 0..$span.TotalMinutes)
	{
	   $body = @{
			ServerName = $env:COMPUTERNAME
			CPULoad = Get-Random -Minimum 1 -Maximum 100 # Just simulating the CPU and RAM load to save time in loading sample data
			RAMLoad = Get-Random -Minimum 1 -Maximum 100
			RecordedDateTime = $now.AddMinutes(-$i)
		}

		$result = Invoke-RestMethod -Method Post -Uri $ApiUri -Body $body

		Write-Host $result
	}
}

LoadPastHourSampleData((New-TimeSpan -Hours 2))
Write-Host "Past hour data has been loaded successfully" -ForegroundColor Yellow

LoadPastDaySampleData((New-TimeSpan -Hours 26))
Write-Host "Past day data has been loaded successfully" -ForegroundColor Yellow