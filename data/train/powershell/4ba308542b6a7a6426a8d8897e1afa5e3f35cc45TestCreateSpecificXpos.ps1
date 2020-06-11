#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
$xpoFileName = 'C:\AX\Build\Drop\DAXSTDR3\1.0.0.18\Logs\Combined.VAR Model.xpo'
CreateSpecificXPOs($xpoFileName)
Read-Host 'XPO split is done'