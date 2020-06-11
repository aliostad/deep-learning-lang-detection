# Show host with remote TSM enabled
# By bwuch
function ShowRemoteTSM () {

  if ($ShowRemoteTSM) {
  
    Write-CustomOut "..Checking VM Host for remote TSM enabled"
    $startingEAP = $ErrorActionPreference
    $ErrorActionPreference="SilentlyContinue"
    $remoteTSM = @()
    
    foreach ($vmhost in ($VMH)) {
      $socket = new-object Net.Sockets.TcpClient
      $socket.connect($vmhost,22)
      
      if ($socket.Connected) {
        $myObj = "" | select Name,Connected
        $myObj.Name = $vmhost.name
        $myObj.Connected = "TRUE"
        $remoteTSM += $myObj
        $socket.close()
      }   
    }
    $ErrorActionPreference = $startingEAP

    If (($remoteTSM | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $remoteTSMReport += Get-CustomHeader "Hosts with remote tech support enabled : $($remoteTSM.count)" "The following hosts have SSH/remote tech support mode enabled."
      $remoteTSMReport += Get-HTMLTable $remoteTSM
      $remoteTSMReport += Get-CustomHeaderClose
    }
  }
  
  return $remoteTSMReport
}