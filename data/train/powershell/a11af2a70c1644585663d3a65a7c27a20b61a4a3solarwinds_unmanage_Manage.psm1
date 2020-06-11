function Unmanage-Solarwinds([int] $Minutes, [string] $servers)
{
	Write-Host " Please ensure input file contains DNS name of the servers you wish to UNMANAGE OR MANAGE " -ForegroundColor Red
	cmd /C Pause
	cd "C:\Program Files (x86)\SolarWinds\Orion SDK\SWQL Studio"
	Import-Module .\SwisPowerShell.dll
	$Swis = Connect-Swis -Trusted -Hostname server1
	$uris = Get-Content $servers | foreach { Get-SwisData $swis "SELECT URI FROM Orion.Nodes WHERE DNS like '$_'" }
	$srvrs = gc $servers
	if ($uris.Count –ne $srvrs.Count)
	{
		Write-Host “Servers in the input file doesn't exist in Solarwinds or it requires FQDN to be identified” -ForegroundColor Red } 
else {Write-Host “Unmanaging servers in Solarwinds” -ForegroundColor Green}
$uris | ForEach-Object { Set-SwisObject $swis $_ @{Status=9;Unmanaged=$true;UnmanageFrom=[DateTime]::UtcNow;UnmanageUntil=[DateTime]::UtcNow.AddMinutes($minutes)} }
$unmanagedservers = Get-Content $servers | foreach {Get-SwisData $swis "SELECT SysName FROM Orion.Nodes WHERE DNS like '$_'"}
$unmanageduntil = Get-Content $servers | foreach {Get-SwisData $swis "SELECT UnmanageUntil FROM Orion.Nodes WHERE DNS like '$_'"}
"$unmanagedServers".Split(" ") 
"$unmanageduntil".Split(" ") 
Write-Host Above Servers have been Unmanaged  for $Minutes Minutes -ForegroundColor Green
}


function Manage-Solarwinds([string] $servers){ 
cd "C:\Program Files (x86)\SolarWinds\Orion SDK\SWQL Studio"
Import-Module .\SwisPowerShell.dll
$Swis = Connect-Swis -Trusted -Hostname server1
$uris = Get-Content $servers | foreach {Get-SwisData $swis "SELECT URI FROM Orion.Nodes WHERE DNS like '$_'"}
$srvrs = gc $servers
if ($uris.Count –ne $srvrs.Count) { Write-Host “Some or all of the servers in the input file doesn't exist in Solarwinds or it requires FQDN to be identified, Please Add the Domain to the servername” -ForegroundColor Red
	}
	else { Write-Host “managing servers in Solarwinds” -ForegroundColor Green }
	$uris | ForEach-Object { Set-SwisObject $swis $_ @{ Status = 9; Unmanaged = $true; UnmanageFrom = [DateTime]::UtcNow; UnmanageUntil = [DateTime]::UtcNow.AddSeconds(5) } }
	$managedservers = Get-Content $servers | foreach { Get-SwisData $swis "SELECT SysName FROM Orion.Nodes WHERE DNS like '$_'" }
	"$managedServers".Split(" ")
}