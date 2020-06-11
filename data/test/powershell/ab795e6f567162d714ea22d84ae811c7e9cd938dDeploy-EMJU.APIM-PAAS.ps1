#Requires -Version 3.0

Param(
  [string] [Parameter(Mandatory=$true)] $ResourceGroupLocation,
  [string] $ResourceGroupName,   
  [switch] $UploadArtifacts,
  [string] $StorageAccountName,
  [string] $StorageAccountResourceGroupName, 
  [string] $StorageContainerName = $ResourceGroupName.ToLowerInvariant() + '-stageartifacts',
  [string] $ArtifactStagingDirectory = '..\bin\Debug\staging',
  [string] $AzCopyPath = '..\Tools\AzCopy.exe',
  [string] [Parameter(Mandatory=$true)] $SubscriptionID,
  [string] [Parameter(Mandatory=$true)] $SubscriptionName,
  [string] [Parameter(Mandatory=$true)] $TenantID
)



Import-Module Azure -ErrorAction SilentlyContinue

try {
  [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("VSAzureTools-$UI$($host.name)".replace(" ","_"), "2.7")
} catch { }

Set-StrictMode -Version 3


Set-Variable -Name authorization -Value 'SharedAccessSignature uid=5685a64ce591970545030003&ex=2016-01-05T07:45:00.0000000Z&sn=ZwZrKspWK0Cuy+iMbA4idwT9eKaUYZm8R47aVdsYWXOJ5fiZ8GXstfVI6jG+GjF2FqAKPf1Ez7vn6eRm6aWxSg=='
Set-Variable -Name serviceUrl -Value 'https://partnernimbusqa1.management.azure-api.net'
Set-Variable -Name contentType -Value 'application/json'
Set-Variable -Name importContentType -Value 'application/vnd.sun.wadl+xml'
Set-Variable -Name apiVersion -Value 'api-version=2015-09-15'

$invokeArgs = @{}
$invokeArgs.Add("Authorization", $authorization)

# Create Product EMJU_Partner
$body = @{}
$body.Add("name", "EMJU_Partner")
$body.Add("description", "Services for Partners")
$body.Add("terms", "None")
$body.Add("subscriptionRequired", "True")
$body.Add("approvalRequired", "False")
$body.Add("state", "Published")

$methodUri = $($serviceUrl + '/products/emjupartner?' + $apiVersion)
echo $('Invoking Uri ' + $methodUri + ' with body ' + (ConvertTo-Json $body))

# Supported versions: 2014-02-14-preview,2014-02-14,2015-09-15
$response = Invoke-RestMethod -Method PUT -Uri $methodUri -Headers $invokeArgs -ContentType $contentType -Body $(ConvertTo-Json $body)
echo $('Execution completed ')

# Create API with Import
$body = Get-Content '../API_WADL/Partner_Clipping.wadl.xml'

$methodUri = $($serviceUrl + '/apis/partnerclipping?' + $apiVersion + '&import=true&path=services/partner')
echo $('Invoking Uri ' + $methodUri + ' with body ' + $body)

$response = Invoke-RestMethod -Method PUT -Uri $methodUri -Headers $invokeArgs -ContentType $importContentType -Body $body
echo $('Execution completed ')

#Set-AzureRmContext -SubscriptionId $SubscriptionID -TenantId $TenantID # -SubscriptionName $SubscriptionName

#New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation 

#$ApiMgmtContext = New-AzureRmApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName "nimbusqa1"

#New-AzureRmApiManagementProduct -Context $ApiMgmtContext -ProductId "EMJU" -Title "EMJU" -Description "Product for holding all EMJU APIs" -LegalTerms "Available for all customers." -SubscriptionRequired $False -State "Published"