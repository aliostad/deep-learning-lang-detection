. $PSScriptRoot\Get-AzureMediaServicesContext.ps1;
. $PSScriptRoot\Load-AzureMediaServicesDependencies.ps1;
. $PSScriptRoot\New-AzureMediaServicesAsset.ps1;
. $PSScriptRoot\Get-AzureMediaServicesProcessor.ps1;
. $PSScriptRoot\Add-AzureMediaServicesAssetFile;
. $PSScriptRoot\New-AzureMediaServicesJob;

$PublicFunction = @(
    'Get-AzureMediaServicesContext';
    'New-AzureMediaServicesAsset';
    'Get-AzureMediaServicesProcessor';
    'Add-AzureMediaServicesAssetFile';
    'New-AzureMediaServicesJob';
    );
Export-ModuleMember -Function $PublicFunction;

Load-AzureMediaServicesDependencies;

