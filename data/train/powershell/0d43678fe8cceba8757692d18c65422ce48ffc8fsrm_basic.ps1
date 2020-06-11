# Author:	@virtualhobbit
# Website:	http://virtualhobbit.com
# Ref:		Wednesday Tidbit: Protect a VM using SRM and PowerCLI

# Variables
 
$vc = "vc.nl.mdb-lab.com"
$srm = "vc3.uk.mdb-lab.com"
$credential = Get-Credential
 
Connect-ViServer $vc -Credential $credential
 
$SrmConnection = Connect-SrmServer $srm -Credential $credential
$SrmApi = $SrmConnection.ExtensionData
$SrmApi.Protection.ListProtectionGroups().GetInfo() | Format-Table Name,Type
 
$vmToAdd = Get-VM "exchange-mbx5.mail.mdb-lab.com"
$protectionGroups = $srmApi.Protection.ListProtectionGroups()
$targetProtectionGroup = $protectionGroups | where {$_.GetInfo().Name -eq "London" }
 
$targetProtectionGroup.AssociateVms(@($vmToAdd.ExtensionData.MoRef))
$protectionSpec = New-Object VMware.VimAutomation.Srm.Views.SrmProtectionGroupVmProtectionSpec
$protectionSpec.Vm = $vmToAdd.ExtensionData.MoRef
$protectTask = $targetProtectionGroup.ProtectVms($protectionSpec)
while(-not $protectTask.IsComplete()) { sleep -Seconds 1 }
 
Disconnect-ViServer $vc -Confirm:$false
Disconnect-SrmServer $srm -Confirm:$false