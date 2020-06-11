# ---- Virtual Center Details ----
function ShowVCDetails () {

  if ($ShowVCDetails){
   
    Write-CustomOut "..Checking VC Services"
    
    $Services = @(Get-VIServices | Where {$_.Name -ne $null -and $_.Health -ne "OK"})

    if (($Services | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vcDetailsReport += Get-CustomHeader "$VIServer Service Details : $($Services.count)" "The following vCenter Services are not in the required state"
      $vcDetailsReport += Get-HTMLTable ($Services)
      $vcDetailsReport += Get-CustomHeaderClose
    }
  }
  
  return $vcDetailsReport
}