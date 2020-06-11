# ---- Unwanted hardware connected ----		
function ShowUnwantedHardware () {

  if ($ShowUnwantedHardware){  
    
    #Thanks to @lucd http://communities.vmware.com/message/1546618
    $vUnwantedHw = @()

    foreach ($vmguest in ($vm | get-view)) {
        $vmguest.Config.Hardware.Device | where {$_.GetType().Name -match $unwantedHardware} |  %{
        $myObj = "" | select Name,Label
        $myObj.Name = $vmguest.name 
        $myObj.Label = $_.DeviceInfo.Label
        $vUnwantedHw += $myObj
      }
    }
    
    if (($vUnwantedHw | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $unwantedHardwareReport += Get-CustomHeader "Unwanted virtual hardware found : $($vUnwantedHw.count)" "Certain kinds of hardware are unwanted on virtual machines as they may cause unnecessary vMotion constraints."
      $unwantedHardwareReport += Get-HTMLTable $vUnwantedHw
      $unwantedHardwareReport += Get-CustomHeaderClose
    }
  }
 
  return $unwantedHardwareReport
}