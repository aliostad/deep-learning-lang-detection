# ---- Single Storage VMs ----
function ShowSingleStorage () {

  if ($ShowSingle) {
    
    Write-CustomOut "..Checking Datastores assigned to single hosts for VMs"
    
    $LocalVMs = @($LocalOnly | Get-UnShareableDatastore | Where { $_.VM -notmatch $LVMDoNotInclude }) 

    if (($LocalVMs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $singleStorageReport += Get-CustomHeader "VMs stored on non shared datastores : $($LocalVMs.count)" "The following VMs are located on storage which is only accesible by 1 host, these will not be compatible with VMotion and may be disconnected in the event of host failure"
      $singleStorageReport += Get-HTMLTable $LocalVMs
      $singleStorageReport += Get-CustomHeaderClose
    }
  }

  return $singleStorageReport
}