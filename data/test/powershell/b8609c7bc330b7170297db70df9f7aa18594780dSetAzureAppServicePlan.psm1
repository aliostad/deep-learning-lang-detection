# halt immediately on any errors which occur in this module
$ErrorActionPreference = 'Stop'
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager' -Force -RequiredVersion '0.8.8'

function Invoke(

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $Name,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $ResourceGroupName,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $Location
){

    $ApiVersion = '2014-04-01'
    $ResourceType = 'Microsoft.Web/serverFarms'

    # Azure uniquely identifies an App Service plan by 'ResourceType', 'ResourceGroupName', 'Name'.
    # If there's a resource with properties matching these then the resource requested
    # to be set already exists.
    $ExistingAzureAppServicePlan = AzureResourceManager\Get-AzureResource -ResourceType $ResourceType -ResourceGroupName $ResourceGroupName| ?{$_.Name -eq $Name}

    # handle new
    If(!$ExistingAzureAppServicePlan){
        AzureResourceManager\New-AzureResource `
        -Location $Location `
        -Name $Name `
        -ResourceGroupName $ResourceGroupName `
        -ResourceType $ResourceType `
        -ApiVersion $ApiVersion `
        -PropertyObject @{} `
        -Force
    }
    # handle existing
    Else{
    
        # azure returns location strings with whitespace stripped
        $WhitespaceStrippedLocation = $Location -replace '\s', ''
        if($ExistingAzureAppServicePlan.Location -ne $WhitespaceStrippedLocation){            
            throw "Changing an App Service plan location is (currently) unsupported"
        }

        AzureResourceManager\Set-AzureResource `
        -Name $Name `
        -ResourceGroupName $ResourceGroupName `
        -ResourceType $ResourceType `
        -ApiVersion $ApiVersion `
        -PropertyObject @{}
    }
}

Export-ModuleMember -Function Invoke
