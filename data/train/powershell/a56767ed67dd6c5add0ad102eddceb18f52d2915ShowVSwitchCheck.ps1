# ---- vSwitch Ports Check ----		
function ShowVSwitchCheck () {

  if ($ShowVSwitchCheck){
  
    Write-CustomOut "..Checking vSwitches for ports left"

    $vswitchinfo = @()

    foreach ($vhost in $VMH) {
      foreach ($vswitch in ($vhost|Get-VirtualSwitch)) {
        $vswitchinf = "" | Select VMHost, vSwitch, PortsLeft
        $vswitchinf.VMHost = $vhost
        $vswitchinf.vSwitch = $vswitch.name
        $vswitchinf.PortsLeft = $vswitch.NumPortsAvailable
        $vswitchinfo += $vswitchinf
      }
    }
    
    $vswitchinfo = $vswitchinfo |sort PortsLeft | Where {$_.PortsLeft -lt $($vSwitchLeft)}
    
    if (($vswitchinfo | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vSwitchCheckReport += Get-CustomHeader "vSwitch with less than $vSwitchLeft Port(s) Free : $($vswitchinfo.count)" "The following vSwitches have less than $vSwitchLeft left"
      $vSwitchCheckReport += Get-HTMLTable $vswitchinfo
      $vSwitchCheckReport += Get-CustomHeaderClose
    }		
  }
  
  return $vSwitchCheckReport
}