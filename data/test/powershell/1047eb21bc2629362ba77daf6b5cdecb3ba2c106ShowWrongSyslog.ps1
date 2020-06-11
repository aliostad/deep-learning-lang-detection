# Show VM Hosts with incorrect syslog server
# By bwuch
function ShowWrongSyslog () {

  if ($ShowWrongSyslog) {
  
    Write-CustomOut "..Checking VM Host syslog server"
    $wrongSyslog = @()

    foreach ($vmhost in ($VMH | Where {$_.ConnectionState -ne "Disconnected"} | Select Name, @{N="SLServer";E={$_ | Get-VMHostSyslogServer}} | Where {$_.SLServer -notmatch $syslogserver})) {
      $myObj = "" | select Name,SyslogServer
      $myObj.name = $vmhost.name
      $myObj.SyslogServer = $vmhost.SLServer
      $wrongSyslog += $myObj
    }

    If (($wrongSyslog | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $wrongSyslogReport += Get-CustomHeader "Hosts with the wrong syslog specified : $($wrongSyslog.count)" "The following hosts do not have a proper syslog of $syslogserver specified."
      $wrongSyslogReport += Get-HTMLTable $wrongSyslog
      $wrongSyslogReport += Get-CustomHeaderClose
    }
  }
  
  return $wrongSyslogReport
}