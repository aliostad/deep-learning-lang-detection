param (
  [Parameter(Mandatory=$True,Position=1)]
  $apiUrl,
  [Parameter(Mandatory=$False,Position=2)]
  $apiUser,
  [Parameter(Mandatory=$True,Position=3)]
  $apiPassword,
  $apiOrg = 'Tier3',
  $apiSpace = 'Dev',
  [Parameter(Mandatory=$True)]
  $brokerName,
  [Parameter(Mandatory=$True)]
  $brokerUrl,
  [Parameter(Mandatory=$True)]
  $brokerUserName,
  [Parameter(Mandatory=$True)]
  $brokerPassword
)

.\cf.exe api $apiUrl
.\cf.exe login -a $apiUrl -u $apiUser -p $apiPassword -o $apiOrg -s $apiSpace

# Look to see if this is already connected
$jsonServiceBrokers = .\cf.exe curl -X 'GET' /v2/service_brokers
$serviceBrokers = "$jsonServiceBrokers" | ConvertFrom-Json
foreach ($resource in $serviceBrokers.resources) {
  if ($resource.entity.name -eq $brokerName -and $resource.entity.broker_url -eq $brokerUrl) {
    Write-Host "Service $brokerName already exists for url $brokerUrl not registering"
    exit 0
  }
}

.\cf.exe delete-service-broker $brokerName -f
.\cf.exe create-service-broker $brokerName $brokerUserName $brokerPassword $brokerUrl

if ($? -eq $false) {
  Write-Error "Failed to create service broker $brokerName for url $brokerUrl."
  exit 1
}

$jsonresponse = .\cf.exe curl /v2/service_plans -X 'GET'

if ($? -eq $false) {
  Write-Error "Failed to get service plans."
  exit 1
}

$response = "$jsonresponse" | ConvertFrom-Json

# Find the 'free' plan by guid and make it public
$guid = $response.resources | ForEach-Object { if ($_.entity.unique_id -eq '69d2ffd5-0902-46f5-a603-e56354e430ef') { return $_.metadata.guid } }

Write-Host "Making Service Plan $guid Public"
.\cf.exe curl /v2/service_plans/$guid -X 'PUT' -d '{\"public\":true}' | Out-Null

if ($? -eq $false) {
  Write-Error "Failed to set plan $guid to public."
  exit 1
}