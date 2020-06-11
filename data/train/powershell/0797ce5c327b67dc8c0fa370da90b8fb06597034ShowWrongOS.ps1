# Show VMs with wrong OS selected
# By bwuch
function ShowWrongOS () {

  if ($ShowWrongOS) {
  
    Write-CustomOut "..Finding guests with wrong OS selected."
    $wrongOS = @()
    
    foreach ($vmguest in ($VM | get-view | where ({ $_.Guest.GuestFullname -ne $NULL -AND $_.Guest.GuestFullname -ne $_.Summary.Config.GuestFullName}))) {
      $myObj = "" | select Name,InstalledOS,SelectedOS
      $myObj.Name = $vmguest.name
      $myObj.InstalledOS = $vmguest.Guest.GuestFullName
      $myObj.SelectedOS = $vmguest.Summary.Config.GuestFullName
      $wrongOS += $myObj
    }

    If (($wrongOS | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $wrongOSReport += Get-CustomHeader "Guests with wrong OS : $($wrongOS.count)" "The following virtual machines contain operating systems other than the ones selected in the VM configuration."
      $wrongOSReport += Get-HTMLTable $wrongOS
      $wrongOSReport += Get-CustomHeaderClose
    }
  }
  
  return $wrongOSReport
}