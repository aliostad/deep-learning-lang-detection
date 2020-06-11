#Load the AX PS libary
$SetupRegistryPath = "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup"
$x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")
$dstFolder = 'C:\AX\Backup\Modelstore'
Export-AXModelStore -File "$dstFolder\CleanAX.axmodelstore" -Database "WAXTest_model" -Details
Read-Host "We're done. What about you?"