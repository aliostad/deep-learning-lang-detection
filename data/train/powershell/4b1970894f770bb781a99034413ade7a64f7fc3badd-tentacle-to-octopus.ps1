param($vmName,$location,$thumbprint)

Add-Type -Path 'Newtonsoft.Json.dll'
Add-Type -Path 'Octopus.Client.dll' 

Write-Host "######################################"
Write-Host "Configure server tentacle"
Write-Host "######################################"

$octopusApiKey = 'API-ISUO3MDTAYZUQRAPW1NN46RKJOU'
$octopusURI = 'http://internalapp1:8080'

$endpoint = new-object Octopus.Client.OctopusServerEndpoint $octopusURI, $octopusApiKey
$repository = new-object Octopus.Client.OctopusRepository $endpoint

$environment = $repository.environments.findbyname("ui-test");

$tentacle = New-Object Octopus.Client.Model.MachineResource

$tentacle.name = "UI Test"
$tentacle.EnvironmentIds.Add($environment.id)
$tentacle.Roles.Add("APPSERVER")
$tentacle.Roles.Add("DBSERVER")

$tentacleEndpoint = New-Object Octopus.Client.Model.Endpoints.ListeningTentacleEndpointResource
$tentacle.EndPoint = $tentacleEndpoint
$tentacle.Endpoint.Uri = "https://$vmName.$location.cloudapp.azure.com:10933"

$tentacle.Endpoint.Thumbprint = $thumbprint

$repository.machines.create($tentacle)
