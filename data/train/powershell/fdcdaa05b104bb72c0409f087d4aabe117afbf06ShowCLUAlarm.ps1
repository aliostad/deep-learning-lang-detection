# ---- Cluster Config Issues ----
function ShowCLUAlarm () {

  if ($ShowCLUAlarm){
   
    Write-CustomOut "..Checking Cluster Configuration Issues"
    
    $cluAlarms = @()
    $clusviews = Get-View -ViewType ClusterComputeResource

    foreach ($clusview in $clusviews) {
      if ($clusview.ConfigIssue) {           
        $CluConfigIssues = $clusview.ConfigIssue

        Foreach ($CluConfigIssue in $CluConfigIssues) {
          $Details = "" | Select-Object Name, Message
          $Details.name = $clusview.name
          $Details.Message = $CluConfigIssue.FullFormattedMessage
          $clualarms += $Details
        }
      }
    }

    if (($clualarms | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $cluAlarms = $cluAlarms | sort name
      $cluAlarmReport += Get-CustomHeader "Cluster(s) Config Issue(s) : $($CluAlarms.count)" "The following alarms have been registered against clusters in vCenter"
      $cluAlarmReport += Get-HTMLTable $cluAlarms
      $cluAlarmReport += Get-CustomHeaderClose                                                                                                                                                                                                                      
    }
  }
  
  return $cluAlarmReport
}