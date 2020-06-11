<#
.SYNOPSIS
    update Nic on vswitchs.
.DESCRIPTION
    this will update the Nics assigned for a vswitch
.NOTES
    File Name      : fun_update_pg.ps1
    Author         : gajendra d ambi
    Date           : January 2016
    recommended    : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware 
#>

#Start of script
#start of function
Function fun_update_pg {
$cluster = Read-Host "name of the cluster(hint-type * to include all cluster):"
$pg      = Read-Host "name of the portgroup:"
  
  Write-Host "  
  1 - Rename Portgroup
  2 - Change Vlan
  3 - loadbalancepolicy
  4 - NicTeamingPolicy
  "
  $option = Read-Host "choose one of the above:"

   if ($option -eq 1) {
        $newpg  = Read-Host "name of the new protgroup:"
        foreach ($vmhost in (get-cluster $cluster | get-vmhost)) {
       #changing anything on a portgroup sets the vlan to $null, to avoid that let us get & set the same vlanid during this operation
       $vlan = (get-vmhost $vmhost | get-virtualportgroup -Name $pg).VLanId
       get-vmhost $vmhost | get-virtualportgroup -Name $pg | set-virtualportgroup -Name $newpg -VLanId $vlan -Confirm:$false
      }
     }

   if ($option -eq 2) {
      $vlan = Read-Host "vlan id?:"
      foreach ($vmhost in (get-cluster $cluster | get-vmhost)) {
       #changing anything on a portgroup sets the vlan to $null, to avoid that let us get & set the same vlanid during this operation
       get-vmhost $vmhost | get-virtualportgroup -Name $pg | set-virtualportgroup -VLanId $vlan -Confirm:$false
      }
     }

   if ($option -eq 3) {
      "1 - LoadBalanceIP
       2 - LoadBalanceLoadBased
       3 - LoadBalanceSrcMac
       4 - LoadBalanceSrcId
       5 - ExplicitFailover"       
     $option  = Read-Host "type one of the above option:"

     foreach ($vmhost in (get-cluster $cluster | get-vmhost)) {
     #changing anything on a portgroup sets the vlan to $null, to avoid that let us get & set the same vlanid during this operation
     $vlan    = (get-vmhost $vmhost | get-virtualportgroup -Name $pg).VLanId
     if ($option -eq '1') {get-vmhost $vmhost | get-virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceIP        -Confirm:$false}
     if ($option -eq '2') {get-vmhost $vmhost | get-virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceLoadBased -Confirm:$false}
     if ($option -eq '3') {get-vmhost $vmhost | get-virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceSrcMac    -Confirm:$false}
     if ($option -eq '4') {get-vmhost $vmhost | get-virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceSrcId     -Confirm:$false}
     if ($option -eq '5') {get-vmhost $vmhost | get-virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy ExplicitFailover     -Confirm:$false}             
     }
    }
  
   if ($option -eq 4) {
     $a       = (get-virtualportgroup -Name $pg).ExtensionData.ComputedPolicy.NicTeaming.NicOrder.ActiveNic
     $b       = (get-virtualportgroup -Name $pg).ExtensionData.ComputedPolicy.NicTeaming.NicOrder.StandbyNic
     $vmnics  = ($a + $b) | sort
     $vmnic0  = $vmnics[0]
     $vmnic1  = $vmnics[1]
     
     Write-Host "
                 1 - $vmnic0 active  $vmnic1 standby
                 2 - $vmnic0 standby $vmnic1 active
                 3 - $vmnic0 unused  $vmnic1 active
                 4 - $vmnic1 active  $vmnic0 standby
                 5 - $vmnic1 standby $vmnic0 active
                 6 - $vmnic1 unused  $vmnic0 active"
     write-host "7 - $vmnic0 active  $vmnic1 active" -ForegroundColor Yellow
     
     $option = Read-Host "choose your option:"
     
        foreach ($vmhost in (get-cluster $cluster | get-vmhost)) { 
         if ($option -eq "1") {Get-VMHost $vmhost | Get-Virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicActive  $vmnic0 -MakeNicStandby $vmnic1 -Confirm:$false}
         if ($option -eq "2") {Get-VMHost $vmhost | Get-Virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicStandby $vmnic0 -MakeNicActive  $vmnic1 -Confirm:$false}
         if ($option -eq "3") {Get-VMHost $vmhost | Get-Virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicUnused  $vmnic0 -MakeNicActive  $vmnic1 -Confirm:$false}
         if ($option -eq "4") {Get-VMHost $vmhost | Get-Virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicActive  $vmnic0 -MakeNicStandby $vmnic1 -Confirm:$false}
         if ($option -eq "5") {Get-VMHost $vmhost | Get-Virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicStandby $vmnic0 -MakeNicActive  $vmnic1 -Confirm:$false}
         if ($option -eq "6") {Get-VMHost $vmhost | Get-Virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicUnused  $vmnic0 -MakeNicActive  $vmnic1 -Confirm:$false}
         if ($option -eq "7") {Get-VMHost $vmhost | Get-Virtualportgroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicActive  $vmnic0 -MakeNicActive  $vmnic1 -Confirm:$false}
    }
  }
}
#end of function
fun_update_pg
#End of script
