#Requires -Version 3.0
#Requires -Module AzureRM.Resources
#Requires -Module Azure.Storage

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupLocation,
    [string] $ResourceGroupName = 'apimanagement-dev-rg',
    [string] $TemplateFile = 'azuredeploy.json',
    [string] $TemplateParametersFile = 'azuredeploy.parameters.json',
    [string] $DSCSourceFolder = 'DSC',
    [switch] $ValidateOnly
)

try {
    [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("VSAzureTools-$UI$($host.name)".replace(' ','_'), '2.9.6')
} catch { }

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3

function Format-ValidationOutput {
    param ($ValidationOutput, [int] $Depth = 0)
    Set-StrictMode -Off
    return @($ValidationOutput | Where-Object { $_ -ne $null } | ForEach-Object { @('  ' * $Depth + ': ' + $_.Message) + @(Format-ValidationOutput @($_.Details) ($Depth + 1)) })
}

$OptionalParameters = New-Object -TypeName Hashtable
$TemplateFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateFile))
$TemplateParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile))

# Create or update the resource group using the specified template file and template parameters file
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force

$ErrorMessages = @()
$DeploymentOutput = $null

if ($ValidateOnly) {
    $ErrorMessages = Format-ValidationOutput (Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
                                                                                  -TemplateFile $TemplateFile `
                                                                                  -TemplateParameterFile $TemplateParametersFile `
                                                                                  @OptionalParameters `
                                                                                  -Verbose)
}
else {
    $DeploymentOutput = New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
                                       -ResourceGroupName $ResourceGroupName `
                                       -TemplateFile $TemplateFile `
                                       -TemplateParameterFile $TemplateParametersFile `
                                       @OptionalParameters `
                                       -Force -Verbose `
                                       -ErrorVariable ErrorMessages

    $ErrorMessages = $ErrorMessages | ForEach-Object { $_.Exception.Message.TrimEnd("`r`n") }
}

if ($ErrorMessages)
{
    "", ("{0} returned the following errors:" -f ("Template deployment", "Validation")[[bool]$ValidateOnly]), @($ErrorMessages) | ForEach-Object { Write-Output $_ }
}
else
{
    # Parse the parameter file
    $JsonContent = Get-Content $TemplateParametersFile -Raw | ConvertFrom-Json
    $JsonParameters = $JsonContent | Get-Member -Type NoteProperty | Where-Object {$_.Name -eq "parameters"}

    if ($JsonParameters -eq $null) {
        $JsonParameters = $JsonContent
    }
    else {
        $JsonParameters = $JsonContent.parameters
    }

    $ServiceName = $DeploymentOutput.Outputs["apiManagementServiceName"].Value
    $ApiManagementContext = New-AzureRmApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName

    # Import APIs
    $ApiSpecifications = $JsonParameters.apiSpecifications.value
    
    foreach ($Spec in $ApiSpecifications) {
        $Name = $Spec.name
        $Url = $Spec.swaggerUrl
        $ApiPath = $Spec.path

        $ExistingApi = Get-AzureRmApiManagementApi -Context $ApiManagementContext -Name $Name

        if ($ExistingApi -ne $null)
        {
            # Remove if exists.
            Remove-AzureRmApiManagementApi -Context $ApiManagementContext -ApiId $ExistingApi.ApiId
        }

        Import-AzureRmApiManagementApi -Context $ApiManagementContext -SpecificationFormat Swagger -SpecificationUrl $Url -Path $ApiPath        
   }    
}