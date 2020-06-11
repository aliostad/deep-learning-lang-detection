# Show mis-named VMs
# By bwuch
function ShowMisnamedVM () {

  if ($ShowMisnamedVM) {
  
    Write-CustomOut "..Finding mis-named VMs"
    $misnamed = @()
    
    foreach ($vmguest in ($FullVM | where { $_.Guest.HostName -ne $NULL -AND $_.Guest.HostName -notmatch $_.Name })) {
      $myObj = "" | select VMName,GuestName
      $myObj.VMName = $vmguest.name
      $myObj.GuestName = $vmguest.Guest.HostName
      $misnamed += $myObj
    }
      
    If (($misnamed | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $misnamedVMReport += Get-CustomHeader "Mis-named virtual machines : $($misnamed.count)" "The following guest names do not match the name inside of the guest."
      $misnamedVMReport += Get-HTMLTable $misnamed
      $misnamedVMReport += Get-CustomHeaderClose
    }
  }
  
  return $misnamedVMReport
}