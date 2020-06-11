# ---- No VM Tools ----
function ShowVMsWithOutTools () {
  
  if ($ShowTools){
    Write-CustomOut "..Checking VM Tools"
    $NoTools = @($FullVM | Where {$_.Runtime.Powerstate -eq "poweredOn" -And ($_.Guest.toolsStatus -eq "toolsNotInstalled" -Or $_.Guest.ToolsStatus -eq "toolsNotRunning")} | Select Name, @{N="Status";E={$_.Guest.ToolsStatus}} |sort Name)

    If (($NoTools | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vmsWithOutToolsReport += Get-CustomHeader "No VMTools : $($NoTools.count)" "The following VMs do not have VM Tools installed or are not running, you may gain increased performance and driver support if you install VMTools"
      $vmsWithOutToolsReport += Get-HTMLTable $NoTools
      $vmsWithOutToolsReport += Get-CustomHeaderClose
    }
  }

  return $vmsWithOutToolsReport
}