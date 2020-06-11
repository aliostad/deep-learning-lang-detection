Switch-AzureMode AzureResourceManager

#region publicIPAddresses
#Resource Types: Microsoft.Network/publicIPAddresses
Set-AzurePublicIpAddress # set the desired state for the resource
Remove-AzurePublicIpAddress # remove a public IP address
New-AzurePublicIpAddress # create a new public IP address
Get-AzurePublicIpAddress # get an existing public IP address.

#Example
$vip = New-AzurePublicIpAddress -ResourceGroupName "mvaiias2" -Name "VIP1" -Location "West US" -AllocationMethod Dynamic -DomainNameLabel "mvaiaasv2"
#endregion

#region virtualNetworks
#Resource Types: Microsoft.Network/virtualNetworks

Set-AzureVirtualNetwork # specifies the desired state of a VNET
Remove-AzureVirtualNetwork # remove a VNET
New-AzureVirtualNetwork # create a new VNET
Get-AzureVirtualNetwork # retrieve a VNET configuration
Set-AzureVirtualNetworkSubnetConfig # specifies the desired state of a subnet configuration
Remove-AzureVirtualNetworkSubnetConfig # remove a subnet
New-AzureVirtualNetworkSubnetConfig # create a new subnet configuration
Get-AzureVirtualNetworkSubnetConfig # retrieve a subnet configuration
Add-AzureVirtualNetworkSubnetConfig # add a subnet configuration to a VNET

#Example
$subnet = New-AzureVirtualNetworkSubnetConfig -Name "Subnet-1" -AddressPrefix "10.0.64.0/24"
$vnet = New-AzureVirtualNetwork -Name "VNET" -ResourceGroupName "mvaiias2" -Location "West US" -AddressPrefix "10.0.0.0/16" -Subnet $subnet
$subnet = Get-AzureVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet
#endregion

#region loadBalancers
#Resource Types: Microsoft.Network/loadBalancers

Set-AzureLoadBalancer # specifies the desired state of the load balancer resource
Remove-AzureLoadBalancer # removes the load balancer
New-AzureLoadBalancer # create a new load balancer
Get-AzureLoadBalancer # retrieves the load balancer resource

#Example - Frontend IP Config, RDP NAT rules for 2 NICs, Backend adress pool, Load balancing on port 80, Health probe on port 80, Load balancer resource
$feIpConfig = New-AzureLoadBalancerFrontendIpConfig -Name "FEIP" -PublicIpAddress $vip
$inboundNATRule1 = New-AzureLoadBalancerInboundNatRuleConfig -Name "RDP1" -FrontendIpConfiguration $feIpConfig -Protocol TCP -FrontendPort 3441 -BackendPort 3389
$inboundNATRule2 = New-AzureLoadBalancerInboundNatRuleConfig -Name "RDP2" -FrontendIpConfiguration $feIpConfig -Protocol TCP -FrontendPort 3442 -BackendPort 3389
$beAddressPool = New-AzureLoadBalancerBackendAddressPoolConfig -Name "LBBE"
$healthProbe = New-AzureLoadBalancerProbeConfig -Name "HealthProbe" -RequestPath "HealthProbe.aspx" -Protocol http -Port 80 -IntervalInSeconds 15 -ProbeCount 2
$lbrule = New-AzureLoadBalancerRuleConfig -Name "HTTP" -FrontendIpConfiguration $feIpConfig1 -BackendAddressPool $beAddressPool -Probe $healthProbe -Protocol Tcp -FrontendPort 80 -BackendPort 80
$alb = New-AzureLoadBalancer -ResourceGroupName "SomeResourceGroup" -Name "ALB" -Location "West US" -FrontendIpConfiguration $feIpConfig -InboundNatRule $inboundNATRule1,$inboundNatRule2 -LoadBalancingRule $lbrule -BackendAddressPool $beAddressPool -Probe $healthProbe
#endregion

#region networkInterface
#Resource Types: Microsoft.Network/networkInterfaces

Set-AzureNetworkInterface # specifies the desired state of the network interface
Remove-AzureVMNetworkInterface # removes a network interface from a VM configuration
Remove-AzureNetworkInterface # remove a network interface
New-AzureNetworkInterface # create a new network interface
Get-AzureNetworkInterface # get a network interface
Add-AzureVMNetworkInterface # add a network interface to a VM configuration

#Example - Two NICS in a subnet and associates it with a load balancer resource ($alb) for both port forwarding and load balancing
$nic1 = New-AzureNetworkInterface -ResourceGroupName $resourceGroupName -Name "nic1" -Subnet "Subnet-1" -Location "West US" -LoadBalancerInboundNatRule $alb.InboundNatRules[0] -LoadBalancerBackendAddressPool $alb.BackendAddressPools[0]
$nic2 = New-AzureNetworkInterface -ResourceGroupName $resourceGroupName -Name "nic2" -Subnet "Subnet-1" -Location "West US" -LoadBalancerInboundNatRule $alb.InboundNatRules[1] -LoadBalancerBackendAddressPool $alb.BackendAddressPools[0]
#endregion

#region storageAccounts
#Resource Types: Microsoft.Storage/storageAccounts

Set-AzureStorageAccount # specify the desired state of a storage account
Remove-AzureStorageAccount # remove a storage account
New-AzureStorageAccountKey # regenerate the account key of a storage account
New-AzureStorageAccount # create a new storage account
Get-AzureStorageAccountKey  # retrieve the account key of a storage account
Get-AzureStorageAccount # retrieve a storage account configuration

#Example
New-AzureStorageAccount -ResourceGroupName "mvaiias2" -Name "mvaiias2" -Location "West US" -Type Standard_LRS
#endregion

#region availibilitySets
#Resource Types: Microsoft.Compute/availabilitySets

Remove-AzureAvailabilitySet # remove an availability set
New-AzureAvailabilitySet # create a new availability set
Get-AzureAvailabilitySet # retrieve an availability set configuration

#Example
New-AzureAvailabilitySet -ResourceGroupName "SomeResourceGroup" -Name "AVSet" -Location "West US"
#endregion

#region virtualMachines
#Resource Types: Microsoft.Compute/virtualMachines

New-AzureVMConfig # create a new VM configuration
Set-AzureVMOperatingSystem # specify the OS
Set-AzureVMSourceImage # specify the image used to create the VM
Set-AzureVMOSDisk # specify the location of the OS disk
Add-AzureVMNetworkInterface # specify the networkInterface resource for the VM
New-AzureVM # create the VM
Get-AzureVM # retrieve the configuration of a VM
Update-AzureVM # update a VM

#Example, create VM config, OS, credentials, image, configure OS disk, add NIC, create VM

$vmConfig = New-AzureVMConfig -VMName "mvaiiasv2VM" -VMSize "Standard_A1" -AvailabilitySetId $avset.Id | Set-AzureVMOperatingSystem -Windows -ComputerName "mvaiiasv2VM" -Credential $cred -ProvisionVMAgent -EnableAutoUpdate  | Set-AzureVMSourceImage -PublisherName $publisher -Offer $offer -Skus $sku -Version $version | Set-AzureVMOSDisk -Name "mvaiiasv2VMDisk" -VhdUri "https://mvaiiasv2.blob...." -Caching ReadWrite -CreateOption fromImage  | Add-AzureVMNetworkInterface -Id $nic.Id
New-AzureVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig -Name "contoso-w1"
#endregion
