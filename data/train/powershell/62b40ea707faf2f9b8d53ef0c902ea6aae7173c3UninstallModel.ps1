#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
$SetupRegistryPath = (Set-Parameter "SetupRegistryPath" "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup" )
#Load the AX PS libary
$x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")
$ModelName = 'VAR Model'
$sqlServer = 'MOW04DEV014'
$sqlModelDtaabase = 'LIPSDEV_model'
Uninstall-AXModel -Model $ModelName -NoPrompt -Server $sqlServer -Database $sqlModelDtaabase -Verbose -Details
Read-Host "Uninstall $ModelName done"