

# dot-sourcing Login.ps1 to login to RightScale
. .\Login.ps1

# Get All Servers
$response = $api.GetRequest("servers.xml",$null)
 
$servers = [xml] $response.Content.ReadAsString()
$myserver = $servers.servers.server | where {$_.nickname -eq "PHP1"}
$serverid = $myserver.href.Split("/")[$myserver.href.Split("/").Length - 1 ]
$response = $api.GetRequest("servers/" + $serverid + "/settings",$null)

[xml] $serverSettings = $response.Content.ReadAsString()

#Output server details
($serverSettings.settings)

# Get Private IP address
($serverSettings.settings)."private-ip-address"
