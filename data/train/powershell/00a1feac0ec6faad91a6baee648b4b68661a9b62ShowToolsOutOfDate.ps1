# ---- VM Tools out of date ----
function ShowToolsOutOfDate () {
  
  if ($Showtoolsupdate){
    
    Write-CustomOut "..Checking VM Tools Out of Date"
    
    $UpdateTools = @($FullVM |Where {$_.Guest.ToolsStatus -eq "ToolsOld"} |Select Name, @{N="Status";E={$_.Guest.ToolsStatus}} | sort Name)

    if (($UpdateTools | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $toolsOutOfDateReport += Get-CustomHeader "VM Tools Updates : $($UpdateTools.count)" "The following VMs have issues with VMtools and need to be updated"
      $toolsOutOfDateReport += Get-HTMLTable $UpdateTools
      $toolsOutOfDateReport += Get-CustomHeaderClose
    }
  }
 
  return $toolsOutOfDateReport
}