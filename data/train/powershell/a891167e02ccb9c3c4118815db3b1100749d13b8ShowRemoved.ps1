# ---- VMs Removed ----
function ShowRemoved () {

  if ($ShowRemoved) {

    Write-CustomOut "..Checking for removed VMs"
    $OutputRemovedVMs = @($VIEvent | where {$_.Gettype().Name -eq "VmRemovedEvent"}| Select createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)

    If (($OutputRemovedVMs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $removedReport += Get-CustomHeader "VMs Removed (Last $VMsNewRemovedAge Day(s)) : $($OutputRemovedVMs.count)" "The following VMs have been removed/deleted over the last $($VMsNewRemovedAge) days"
      $removedReport += Get-HTMLTable $OutputRemovedVMs
      $removedReport += Get-CustomHeaderClose
    }
  }
  
  return $removedReport
}