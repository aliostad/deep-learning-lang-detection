# ---- VM Tools connected ----
function ShowToolInstallerConnected () {

  if ($ShowToolsConnected){
    
    Write-CustomOut "..Checking VM Tools Installer connected"
    
    $ToolsConnect = @($FullVM | where {$_.Runtime.ToolsInstallerMounted -eq $true} | select Name, @{N="Connected";E={$_.RunTime.ToolsInstallerMounted}} | sort Name)

    if (($ToolsConnect | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $toolInstallerConnectedReport += Get-CustomHeader "VM Tools Installer connected : $($ToolsConnect.count)" "The following VMs have the VMware Tools installer mounted and may create VMotion violations."
      $toolInstallerConnectedReport += Get-HTMLTable $ToolsConnect
      $toolInstallerConnectedReport += Get-CustomHeaderClose
    }
  }
  
  return $toolInstallerConnectedReport
}