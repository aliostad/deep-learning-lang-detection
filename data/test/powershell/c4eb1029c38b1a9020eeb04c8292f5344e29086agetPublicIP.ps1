switch-azuremode -name AzureResourceManager

$resourceGroupName = "T52-201599-14935"

$resourceType = "Microsoft.Network/publicIpaddresses" 
$apiversion = "2015-05-01-preview"
$name = "rdpIp"

$resource = Get-AzureResource -ResourceGroupName $resourceGroupName -Name $name -ApiVersion $apiversion -ResourceType $resourceType
write-host $resourceGroupName
write-host $resource.Properties.ipAddress

Get-AzureNetworkInterface -ResourceGroupName $resourceGroupName | select Name, {$_.Ipconfigurations.privateIpAddress}



$rg = Get-AzureResourceGroup | where {$_.ResourceGroupName -like "T27*" }
$apiversion = "2015-05-01-preview"
$name = "rdpIp"

foreach($g in $rg)
{
    $g.ResourceGroupName
    (Get-AzureResource -ResourceGroupName $g.ResourceGroupName -name "rdpip" -ApiVersion $apiVersion -ResourceType "Microsoft.Network/PublicIPAddresses").Properties.ipAddress
}