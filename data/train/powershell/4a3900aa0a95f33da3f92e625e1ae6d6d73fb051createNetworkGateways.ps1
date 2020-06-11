$RMvnetLocation = "West Europe"
$resourceGroupName = "vitoResourceGroup1"
$sharedKey = "abc123"

Write-Host " Please setup the Local virtual network on manage.windowsazure.com as described here:https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-arm-asm-s2s-howto/"
Write-Host " Then input the public IP address you have set up for the gateway and press enter. E.g. 168.62.190.190"


$classicVnetGatewayPublicIp = Read-Host
 

# Create the gateway for the classic network
New-AzureRmLocalNetworkGateway -Name VNetClassicNetwork `
    -Location $RMvnetLocation -AddressPrefix "10.0.0.0/20" `
    -GatewayIpAddress $classicVnetGatewayPublicIp -ResourceGroupName $resourceGroupName


$ipaddress = New-AzureRmPublicIpAddress -Name gatewaypubIP`
    -ResourceGroupName $resourceGroupName -Location $RMvnetLocation `
    -AllocationMethod Dynamic

$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet `
    -VirtualNetwork (Get-AzureRmVirtualNetwork -Name VNetARM -ResourceGroupName $resourceGroupName) 

$ipconfig = New-AzureRmVirtualNetworkGatewayIpConfig `
    -Name ipconfig -PrivateIpAddress 10.1.2.4 `
    -SubnetId $subnet.id -PublicIpAddressId $ipaddress.id

New-AzureRmVirtualNetworkGateway -Name v1v2Gateway -ResourceGroupName $resourceGroupName `
    -Location $RMvnetLocation -GatewayType Vpn -IpConfigurations $ipconfig `
    -EnableBgp $false -VpnType RouteBased

Get-AzureRmPublicIpAddress -Name gatewaypubIP -ResourceGroupName $resourceGroupName

Set-AzureVNetGatewayKey -VNetName VNetClassic `
    -LocalNetworkSiteName VNetARM -SharedKey $sharedKey

$vnet01gateway = Get-AzureRmLocalNetworkGateway -Name VNetClassic -ResourceGroupName $resourceGroupName
$vnet02gateway = Get-AzureRmVirtualNetworkGateway -Name v1v2Gateway -ResourceGroupName $resourceGroupName

New-AzureRmVirtualNetworkGatewayConnection -Name arm-asm-s2s-connection `
    -ResourceGroupName $resourceGroupName -Location $RMvnetLocation -VirtualNetworkGateway1 $vnet02gateway `
    -LocalNetworkGateway2 $vnet01gateway -ConnectionType IPsec `
    -RoutingWeight 10 -SharedKey $sharedKey