# ---- VM Alarm ----
function ShowVMAlarm () {

  if ($ShowVMAlarm){
  
    Write-CustomOut "..Checking VM Alarms"
    
    $vmsalarms = @()

    foreach ($VMView in $FullVM) {

      if ($VMView.TriggeredAlarmState) {
        $VMsTriggeredAlarms = $VMView.TriggeredAlarmState

        foreach ($VMsTriggeredAlarm in $VMsTriggeredAlarms) {
          $Details = "" | Select-Object Object, Alarm, Status, Time
          $Details.Object = $VMView.name
          $Details.Alarm = ($valarms |?{$_.value -eq ($VMsTriggeredAlarm.alarm.value)}).name
          $Details.Status = $VMsTriggeredAlarm.OverallStatus
          $Details.Time = $VMsTriggeredAlarm.time
          $vmsalarms += $Details
        }
      }
    }

    if (($vmsalarms | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vmsalarms = $vmsalarms | sort Object
      $vmAlarmReport += Get-CustomHeader "VM(s) Alarm(s) : $($vmsalarms.count)" "The following alarms have been registered against VMs in vCenter"
      $vmAlarmReport += Get-HTMLTable $vmsalarms
      $vmAlarmReport += Get-CustomHeaderClose
    }
  }
  
  return $vmAlarmReport
}