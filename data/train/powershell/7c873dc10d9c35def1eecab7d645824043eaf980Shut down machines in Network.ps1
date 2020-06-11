Import-Module CaaS

# Create a connection
$secpasswd = ConvertTo-SecureString "MyPassword123!" -AsPlainText -Force
$login= New-Object System.Management.Automation.PSCredential ("MyUsername", $secpasswd)

New-CaasConnection -ApiCredentials $login -ApiBaseUri "https://api-au.dimensiondata.com/oec/0.9/"

$devNetwork = Get-CaasNetworks -Name "Ant Dev"
# Now, get all the servers in that network by searching for servers in that network Id.
$devServers = Get-CaasDeployedServer -Network $devNetwork 
 foreach ( $server in $devServers ) {
  Write-Host Shutting down $server.name 
  Set-CaasServerState -Action Shutdown -Server $server
}