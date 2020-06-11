# ---- Datastore OverAllocation ----
function ShowDataStoreOverAllocation () {

  if ($ShowOverAllocation) {
  
    Write-CustomOut "..Checking Datastore OverAllocation"
    
    $storages = $Datastores |Get-View
    $voverallocation = @()
    
    foreach ($storage in $storages) {
      if ($storage.Summary.Uncommitted -gt "0") {
        $Details = "" | Select-Object Datastore, Overallocation
        $Details.Datastore = $storage.name
        $Details.overallocation = [math]::round(((($storage.Summary.Capacity - $storage.Summary.FreeSpace) + $storage.Summary.Uncommitted)*100)/$storage.Summary.Capacity,0)
      
        if ($Details.overallocation -gt $OverAllocation) {
          $voverallocation += $Details
          }
      }
    }
    
    If (($voverallocation | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $dataStoreOverAllocationReport += Get-CustomHeader "Datastore OverAllocation % over $OverAllocation : $($voverallocation.count)" "The following datastores may be overcommitted it is strongly sugested you check these"
      $dataStoreOverAllocationReport += Get-HTMLTable $voverallocation
      $dataStoreOverAllocationReport += Get-CustomHeaderClose
    }			
  }
  
  return $dataStoreOverAllocationReport
}