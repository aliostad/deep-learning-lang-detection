# VCB Garbage
function ShowVCBGarbage () {
  if ($ShowVCBGarbage) {
  
    Write-CustomOut "..Checking VCB Garbage"
    
    $VCBGarbage = $VM |where { (Get-Snapshot -VM $_).name -contains "VCB|Consolidate|veeam|SYMC" } |sort name |select name
    
    If (($VCBGarbage | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vcbGarbageReport += Get-CustomHeader "VCB Garbage : $($VCBGarbage.count)" "The following snapshots have been left over from using VCB, you may wish to investigate if these are still needed"
      $vcbGarbageReport += Get-HTMLTable $VCBGarbage
      $vcbGarbageReport += Get-CustomHeaderClose
    }		
  }
  
  return $vcbGarbageReport
}