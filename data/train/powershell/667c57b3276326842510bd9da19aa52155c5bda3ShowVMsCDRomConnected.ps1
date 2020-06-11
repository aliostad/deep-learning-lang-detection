# ---- CD-Roms Connected ----
function ShowVMsCDRomConnected () {

  if ($ShowCDROM) {

    Write-CustomOut "..Checking for connected CDRoms"
    
    $CDConn = @($VM | Where { $_ | Get-CDDrive | Where { $_.ConnectionState.Connected -eq $true } } | Select Name, VMHost)
    $CDConn = $CDConn | Where { $_.Name -notmatch $CDFloppyConnectedOK }

    if (($CDConn | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vmsCDRomConnectedReport += Get-CustomHeader "VM: CD-ROM Connected - VMotion Violation : $($CDConn.count)" "The following VMs have a CD-ROM connected, this may cause issues if this machine needs to be migrated to a different host"
      $vmsCDRomConnectedReport += Get-HTMLTable $CDConn
      $vmsCDRomConnectedReport += Get-CustomHeaderClose
    }
  }

  return $vmsCDRomConnectedReport
}