# ---- VM Hardware Version ----
function ShowHardwareVersion () {
  if ($ShowHWVer) {
    if ($vSphere -eq $true) {
   
      Write-CustomOut "..Checking VM Hardware Version"

      $HV = @($FullVM | Select Name, @{N="HardwareVersion";E={"Version $($_.Config.Version[5])"}} | Where {$_.HardwareVersion -ne "Version 7"} | sort name)

      if (($HV | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
        $hardwareVersionReport += Get-CustomHeader "VMs with old hardware : $($HV.count)" "The following VMs are not at the latest hardware version, you may gain performance enhancements if you convert them to the latest version"
        $hardwareVersionReport += Get-HTMLTable $HV
        $hardwareVersionReport += Get-CustomHeaderClose	
      }
    }
  }
  
  return $hardwareVersionReport
}