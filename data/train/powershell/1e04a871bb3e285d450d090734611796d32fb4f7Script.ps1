#################################################
#												#
#.NAME											#
#	Microsoft Windows Server Nano Manager		#
#												#
#.AUTHOR										#
#	Ivan Temchenko								#
#												#
#.VERSION										#
#	1.1											#
#												#
#################################################

if(Get-Module Nano-Goodies){
	Remove-Module Nano-Goodies
}
Import-Module ./Nano-Goodies.psm1
Clear-Host
Write-Host "@@ Nano Server Manager @@"
$selection = Show-Menu
switch ($selection) {
	1 { Install-Updates }
	2 { Install-UpdatesRunning }
	3 { Show-InstalledUpdates }
	4 { Write-Host "Not yet implemented..."}
	'x' { exit }
}