function Load_PowerCLI ()
 {
 Add-PSSnapin VMware.VimAutomation.Core
 #Configure PowerCLI to accept multiple connections:
 Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false
 Set-PowerCLIConfiguration -DisplayDeprecationWarnings:$false -Confirm:$false
 }
 
function vCenter_Connect ()
 {
 clear
 [console]::ForegroundColor = "yellow"
 [console]::BackgroundColor= "black"
 [string]$global:sourceVI=Read-Host "Please enter vCenter Server [Ip/FQDN] : "
 $source_credentials = Get-Credential
 Connect-VIServer $sourceVI -credential $source_credentials
 [console]::ResetColor()
 }
 
function disconect_all_vms_cdrom ()
 {
 Get-VM | Get-CDDrive | Where {$_.ConnectionState.Connected} | Set-CDDrive -Connected $false -Confirm:$false
 }

function disconnect_vcenter ()
 {
 Disconnect-VIServer -Server * -Force -confirm:$false
 }

function unload_PowerCLI ()
 {
 Remove-PSSnapin VMware.VimAutomation.Core
 }
 
Load_PowerCLI
vCenter_Connect
disconect_all_vms_cdrom
disconnect_vcenter
unload_PowerCLI