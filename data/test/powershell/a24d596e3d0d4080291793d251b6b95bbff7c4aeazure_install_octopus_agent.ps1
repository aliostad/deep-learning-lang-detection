$vm = Get-AzureVM -Name "OctoVM44" -ServiceName "OctoVM44"
 
$publicConfiguration = ConvertTo-Json -Depth 8 @{
    SasToken               = ""
    ModulesUrl             = "https://octodeploy.blob.core.windows.net/octopus-azure/Octopus.zip"
    ConfigurationFunction  = "Octopus.ps1\OctopusAzureConfig"
    Properties             = @{
        ApiKey = "API-ABC123DEF456789ABC123DEF"
        OctopusServerUrl = "https://demo.octopusdeploy.com/"
        Environments = "Production"
        Roles = "web-server"
        ListenPort = 10933
    }
}
 
$vm = Set-AzureVMExtension `
    -VM $vm `
    -Publisher Microsoft.Powershell `
    -ExtensionName DSC `
    -Version 1.3 `
    -Verbose `
    -PublicConfiguration $publicConfiguration `
$vm | Add-AzureEndpoint -Name "TentacleIn" -Protocol "tcp" -PublicPort 10933 -LocalPort 10933
$vm | Update-AzureVM