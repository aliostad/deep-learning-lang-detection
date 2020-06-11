Param(
	[Parameter(Mandatory=$True)][string]$HostName,
	[string]$LogFile = "log.html",
	[string]$ErrorLogFile = "errorLog.html",
	[int]$TimeBetweenPings = 5
)

Function Log
{
	Param ([Object]$message)
	Write-Output $message | ConvertTo-HTML | Add-Content $LogFile
}

Function LogError 
{
	Param ([Object]$message)
	Write-Output $message | ConvertTo-HTML | Add-Content $ErrorLogFile
}

$ping = New-Object System.Net.NetworkInformation.Ping

while($true) {
	$result = $ping.Send($HostName)	
	$resultMessage = $result | Select-Object Status, Address, RoundtripTime, @{Name="Date";Expression={$(Get-Date -Format o)}}
	if ($resultMessage.Status -ne 'success') { LogError($resultMessage) }
	Log($resultMessage)
	Write-Output $resultMessage
	Start-Sleep -Seconds $TimeBetweenPings
}