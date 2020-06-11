$username = ''
$passwd = ConvertTo-SecureString -String '' -AsPlainText -Force
$cred = New-Object -TypeName pscredential -ArgumentList $username,$passwd

Login-AzureRmAccount -EnvironmentName azurechinacloud -Credential $cred


New-AzureRmResourceGroup -Name BIMVM -Location "China North"

 

$params = @{
"password" = $passwd;
"username" = 'shzhai'
}


Get-AzureRmResourceGroup | ? {$_.ResourceGroupName -match 'bim'} | Remove-AzureRmResourceGroup -Force

New-AzureRmResourceGroup -Name bimtest -Location 'China North'

New-AzureRmResourceGroupDeployment -name 'bimtest' -ResourceGroupName 'bimtest' -TemplateParameterUri https://raw.githubusercontent.com/shzhai/ARMPractices/master/ARMTemplates/azuredeploy.json @params


# 查看资源产生
while ($true) {Find-AzureRmResource -ResourceGroupName bimtest | measure; Start-Sleep -s 2;Clear}


 # 验证测试生效
find-AzureRmResource -ResourceGroupName bimtest -ExtensionResourceType Microsoft.Network/loadBalancers

Name              : loadBalancer
ResourceId        : /subscriptions/abda8356-5cee-4b7f-a2be-1cc415ef78a7/resourceGroups/bimtest/providers/Microsoft.Network/loadBalancers/loadBalancer
ResourceName      : loadBalancer
ResourceType      : Microsoft.Network/loadBalancers
ResourceGroupName : bimtest
Location          : chinanorth
SubscriptionId    : abda8356-5cee-4b7f-a2be-1cc415ef78a7

Get-AzureRmResource -ResourceId /subscriptions/abda8356-5cee-4b7f-a2be-1cc415ef78a7/resourceGroups/bimtest/providers/Microsoft.Network/loadBalancers/loadBalancer | select -ExpandProperty Properties | select -ExpandProperty InboundNatRules

<# Name     Id                                                                                                                                                         Etag                                     Properties
----     --                                                                                                                                                         ----                                     ----------
VM-1-RDP /subscriptions/abda8356-5cee-4b7f-a2be-1cc415ef78a7/resourceGroups/bimtest/providers/Microsoft.Network/loadBalancers/loadbalancer/inboundNatRules/VM-1-RDP W/"f5091c72-8f66-488d-82d6-53583210136a" @{ProvisioningState=Succeeded; FrontendIPCon...
VM-2-RDP /subscriptions/abda8356-5cee-4b7f-a2be-1cc415ef78a7/resourceGroups/bimtest/providers/Microsoft.Network/loadBalancers/loadbalancer/inboundNatRules/VM-2-RDP W/"f5091c72-8f66-488d-82d6-53583210136a" @{ProvisioningState=Succeeded; FrontendIPCon...
#>