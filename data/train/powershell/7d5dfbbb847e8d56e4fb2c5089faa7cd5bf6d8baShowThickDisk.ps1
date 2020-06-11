# Show VMs with thick disks
# By bwuch
function ShowThickDisk () {

  if ($ShowThickDisk) {
      
    Write-CustomOut "..Checking for thick provisioned virtual disk files"
    $thickdisks = @()

    foreach ($vmguest in ($VM | get-view)) {
      $name = $vmguest.name
      $vmguest.Config.Hardware.Device | where {$_.GetType().Name -eq "VirtualDisk"} |  %{
        
        if(!$_.Backing.ThinProvisioned) {
          $myObj = "" |
          select Name,Label,File,CapacityGB
          $myObj.Name = $name
          $myObj.Label = $_.DeviceInfo.Label
          $myObj.File = $_.Backing.FileName
          $myObj.CapacityGB = [math]::round(($_.CapacityInKB / 1024 / 1024),2)
          $thickdisks += $myObj
        }
      }   
    }
    
    If (($thickdisks | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $thickDiskReport += Get-CustomHeader "Thick provisioned virtual disks : $($thickdisks.count)" "Standard virtual disks in this environment are thin provisioned.  Thick provisioned disks represent a possible waste of storage space and should only be used when disk I/O performance is a top concern."
      $thickDiskReport += Get-HTMLTable $thickdisks
      $thickDiskReport += Get-CustomHeaderClose
    }
  }
  
  return $thickDiskReport
}