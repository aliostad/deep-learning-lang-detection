#Requires -Version 3.0

Param(
  [string] $TemplateFile = '..\Templates\DeploymentTemplate.json',
  [string] $TemplateParametersFile = '..\Templates\DeploymentTemplate.param.dev.json'
)

Set-StrictMode -Version 3
Import-Module Azure -ErrorAction SilentlyContinue
Add-AzureAccount
Switch-AzureMode AzureResourceManager

try {
    $AzureToolsUserAgentString = New-Object -TypeName System.Net.Http.Headers.ProductInfoHeaderValue -ArgumentList 'VSAzureTools', '1.4'
    [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.UserAgents.Add($AzureToolsUserAgentString)
} catch { }

$TemplateFile = [System.IO.Path]::Combine($PSScriptRoot, $TemplateFile)
$TemplateParametersFile = [System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile)
$ResourceGroupLocation= Read-Host -Prompt "Please enter the existing resource group location, e.g. West US"
$ResourceGroupName= Read-Host -Prompt "Please enter the name of the existing resource group"
$adminName= Read-Host -Prompt "Please enter a new administrator username for the WAF VM"
$ipAddress= Read-Host -Prompt "Please enter a new internal static IP Address for the WAF VM"
$NICName= Read-Host -Prompt "Please enter a name for the new WAF VM NIC"
$wafName= Read-Host -Prompt "Please enter a name for the new WAF VM"
$inboundNATRuleGUIName= Read-Host -Prompt "Please enter a name for the new WAF VM MGMT GUI NAT Rule"
[int]$inboundNATRuleGUIExternalPort= Read-Host -Prompt "Please enter a port number for the new WAF VM MGMT GUI NAT Rule (eg 9443)"
$inboundNATRuleSSHName= Read-Host -Prompt "Please enter a name for the new WAF VM SSH NAT Rule"
[int]$inboundNATRuleSSHExternalPort= Read-Host -Prompt "Please enter a port number for the new WAF VM SSH NAT Rule (eg 9022)"
$vNet= Get-AzureVirtualNetwork -ResourceGroupName $ResourceGroupName
$availabilitySetName = Get-AzureAvailabilitySet -ResourceGroupName $ResourceGroupName
$loadBalancerName= Get-AzureLoadBalancer -ResourceGroupName $ResourceGroupName
$stor= Get-AzureStorageAccount -ResourceGroupName $ResourceGroupName
$key= Get-AzureStorageAccountKey -ResourceGroupName $ResourceGroupName -StorageAccountName $stor.Name
$context= New-AzureStorageContext -StorageAccountName $stor.Name -StorageAccountKey $key.key1
$container= Get-AzureStorageContainer -Context $context

#Create new Inbound NAT Rules on existing load balancer
$loadBalancerName | Add-AzureLoadBalancerInboundNatRuleConfig -Name $inboundNATRuleGUIName `
    -FrontendIPConfiguration $loadBalancerName.FrontendIPConfigurations[0] `
    -Protocol Tcp `
    -FrontendPort $inboundNATRuleGUIExternalPort `
    -BackendPort 443

$loadBalancerName | Add-AzureLoadBalancerInboundNatRuleConfig -Name $inboundNATRuleSSHName `
	-FrontendIPConfiguration $loadBalancerName.FrontendIPConfigurations[0] `
	-Protocol Tcp `
	-FrontendPort $inboundNATRuleSSHExternalPort `
	-BackendPort 22 | Set-AzureLoadBalancer

#Read the JSON Parameter file
$json= Get-Content -Raw -Path $TemplateParametersFile | ConvertFrom-Json

#Write parameters to JSON Paramter file
$json.resourceGroupName.value = $ResourceGroupName
$json.virtualNetworkName.value = $vNet.Name
$json.SubnetName.value = $vNet.Subnets[0].Name
$json.staticIPAddress.value = $ipAddress
$json.NICName.value = $NICName
$json.availabilitySetName.value = $availabilitySetName.Name
$json.loadBalancerName.value = $loadBalancerName.Name
$json.wafName.value = $wafName
$json.inboundNATRuleGUIName.value = $inboundNATRuleGUIName
$json.inboundNATRuleGUIExternalPort.value = $inboundNATRuleGUIExternalPort
$json.inboundNATRuleSSHName.value = $inboundNATRuleSSHName
$json.inboundNATRuleSSHExternalPort.value = $inboundNATRuleSSHExternalPort
$json.adminUsername.value = $adminName
$json.userImageStorageAccountName.value = $stor.Name
$json.userImageStorageContainerName.value = $container.Name
$json | ConvertTo-Json | Set-Content -Path $TemplateParametersFile


###Start the Deployment
New-AzureResourceGroupDeployment -Name $wafName -ResourceGroupName $ResourceGroupName -TemplateParameterFile $TemplateParametersFile -TemplateFile $TemplateFile -Force -Verbose

$url= Get-AzurePublicIpAddress -ResourceGroupName $ResourceGroupName
Write-Host ("You can connect to the new WAF via https://{0}:{1}/" -f $url.DnsSettings.Fqdn, $inboundNATRuleGUIExternalPort.ToString())