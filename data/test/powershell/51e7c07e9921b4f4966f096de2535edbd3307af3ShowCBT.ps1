# —- Show CBT —– #
function ShowCBT () {
  if ($ShowCBT) {
  
    Write-CustomOut "..Checking for CBT status"
    
    $cbt = @()
    
    foreach ($vmguest in $FullVM){
      $name = $vmguest.name
      $vmguest.Config.ChangeTrackingEnabled | %{
        if ($CBTdefault -eq 'true'){
          if (!$vmguest.Config.ChangeTrackingEnabled -eq 'true'){
            $myObj = "" | select Name,ChangeBlockTrackingStatus
            $myObj.Name = $name
            $myObj.ChangeBlockTrackingStatus = $vmguest.Config.ChangeTrackingEnabled
            $cbt += $myObj
          }
        } else {
          if ($vmguest.Config.ChangeTrackingEnabled -eq 'true'){
            $myObj = "" | select Name,ChangeBlockTrackingStatus
            $myObj.Name = $name
            $myObj.ChangeBlockTrackingStatus = $vmguest.Config.ChangeTrackingEnabled
            $cbt += $myObj
          }
        }
      }
    }

    if (($cbt | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      if ($CBTdefault -eq 'true'){
        $myReport += Get-CustomHeader "Change Block Tracking Disabled Count : $($cbt.count)" "The following servers do not track changed blocks and may not be backed up"
      } else{
        $myReport += Get-CustomHeader "Change Block Tracking Enabled Count : $($cbt.count)" "The following servers are tracking changed blocks and may be creating unnecessary overhead"
      }
      
      $showCBTReport += Get-HTMLTable ($cbt | Sort-Object name)
      $showCBTReport += Get-CustomHeaderClose
    }
  }
  
  return $showCBTReport
}