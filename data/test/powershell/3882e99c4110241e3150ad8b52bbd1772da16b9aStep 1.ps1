Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"

$ErrorActionPreference = "Stop"
$DebugPreference = "SilentlyContinue"

$workingDir = (Split-Path -parent $MyInvocation.MyCommand.Definition) + "\"

. $workingDir"Common\Common.ps1"
. Common

. $workingDir"Common\RunRemotely.ps1"
. $workingDir"Common\CreateVm.ps1"
. $workingDir"Common\RdpManageCert.ps1"


Write-Status "Adding Virtual Network..."
. $workingDir"Add-VirtualNetworkSite.ps1"
Add-VirtualNetworkSite $virtualNetworkName $location $addressSpaceAddressPrefix $frontEndSubnetAddressPrefix $backEndSubnetAddressPrefix


# CreateServices0 creates the cloud service, so it must come first
Write-Status "Creating Services 0..."
. $workingDir"Services\CreateServices.ps1"
CreateServices0


Write-Status "Creating Services 1..."
CreateServices1


. $workingDir"Web\CreateWeb.ps1"
CreateWeb


Write-Status "Setting Web Endpoints..."
. $workingDir"Web\SetWebEndpoints.ps1"

. $workingDir"Memcached\CreateMemcached.ps1"
CreateMemcached


. $workingDir"Common\SetSshEndpoints.ps1"

Write-Status "Creating Debugging..."
. $workingDir"Debugging\CreateDebugging.ps1"
CreateDebugging


Write-Status "Done!"