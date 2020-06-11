#$ErrorActionPreference = "Stop"

. "$PSScriptRoot\Common.ps1"
. "$PSScriptRoot\CreateAzurePackage.ps1"
. "$PSScriptRoot\DatabaseAzure.ps1"
. "$PSScriptRoot\ManageAzureServices.ps1"
. "$PSScriptRoot\ManageAzureStorage.ps1"
. "$PSScriptRoot\ManageAzureResourceGroup.ps1"
. "$PSScriptRoot\ManageAzureRedisCache.ps1"
. "$PSScriptRoot\PublishCloudService.ps1"
. "$PSScriptRoot\UpdateAzureCloudConfigs.ps1"
. "$PSScriptRoot\UpdateSitefinityConfigs.ps1"
. "$PSScriptRoot\CertificatesManagement.ps1"

#configure powershell with Azure 1.7 modules
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
$config = Get-Settings "$PSScriptRoot\Configuration\config.json"