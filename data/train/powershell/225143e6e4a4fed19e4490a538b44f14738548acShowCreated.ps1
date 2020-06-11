# ---- VMs created or Cloned ----
function ShowCreated () {

  if ($ShowCreated) {

    Write-CustomOut "..Checking for created or cloned VMs"

    $VIEvent = Get-VIEvent -maxsamples 10000 -Start ($Date).AddDays(-$VMsNewRemovedAge)
    $OutputCreatedVMs = @($VIEvent | where {$_.Gettype().Name -eq "VmCreatedEvent" -or $_.Gettype().Name -eq "VmBeingClonedEvent" -or $_.Gettype().Name -eq "VmBeingDeployedEvent"} | Select createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)
    
    If (($OutputCreatedVMs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $createdReport += Get-CustomHeader "VMs Created or Cloned (Last $VMsNewRemovedAge Day(s)) : $($OutputCreatedVMs.count)" "The following VMs have been created over the last $($VMsNewRemovedAge) Days"
      $createdReport += Get-HTMLTable $OutputCreatedVMs
      $createdReport += Get-CustomHeaderClose
    }
  }
 
  return $createdReport
}