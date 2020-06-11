#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
$SetupRegistryPath = (Set-Parameter "SetupRegistryPath" "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup" )
#Load the AX PS libary
$x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")
Install-AXModel -File "C:\AX\Build\Drop\DAXSTDR3\1.0.0.18\application\appl\VAR Model.axmodel" -Details -NoPrompt -Server "MOW04DEV014" -Database "MicrosoftDynamicsAX_model" -OutVariable out -Verbose -createparents
Read-Host 'Model has been imported succesfully'