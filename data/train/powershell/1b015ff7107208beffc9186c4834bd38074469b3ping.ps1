# ping - check if server is online
param([parameter(Mandatory = $true)][String]$server)

$ErrorActionPreference = "Stop"

try {

   . ..\_lib\log.ps1
   LogMessage "main" "setting up environment"
   [Environment]::CurrentDirectory = $pwd

   LogMessage "main" "start"
   LogMessage "main" "server: $server"

   $ping = new-object System.Net.NetworkInformation.Ping
   $reply = $ping.send($server)

   if ($reply.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
      LogMessage "main" "success"
      [Environment]::Exit(0)
   } else {
      LogMessage "main" "failure"
      [Environment]::Exit(4100)
   }

} catch [System.Net.NetworkInformation.PingException] {
   LogMessage "main" "failure"
   [Environment]::Exit(4200)
} catch [System.Exception] {
   LogMessage "main" "failure"
   write-host($_.Exception.ToString())
   [Environment]::Exit(4000)
}
