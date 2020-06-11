# ---- Floppys Connected ----
function ShowVMsFloppyConnected () {

  if ($ShowFloppy){

  Write-CustomOut "..Checking for connected floppy drives"

  $Floppy = @($VM | Where { $_ | Get-FloppyDrive | Where { $_.ConnectionState.Connected -eq $true } } | Where { $_.Name -notmatch $CDFloppyConnectedOK } | Select Name, VMHost)
    $Floppy = $Floppy | Where { $_.Name -notmatch $CDFloppyConnectedOK }

    if (($Floppy | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vmsFloppyConnectedReport += Get-CustomHeader "VM:Floppy Drive Connected - VMotion Violation : $($Floppy.count)" "The following VMs have a floppy disk connected, this may cause issues if this machine needs to be migrated to a different host"
      $vmsFloppyConnectedReport += Get-HTMLTable $Floppy
      $vmsFloppyConnectedReport += Get-CustomHeaderClose
    }
  }

  return $vmsFloppyConnectedReport
}