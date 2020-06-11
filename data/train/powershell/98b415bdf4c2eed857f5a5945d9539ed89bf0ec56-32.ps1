$serviceName = "[cloud service name]"

# Specify the admin credentials
$adminUser = "[admin username]"
$password = "[admin password]"

# Specify the region (must match the same region as your virtual network)
$location = "[region name]"

# Specify the virtual machine names
$vmName1 = "intranet1"
$vmName2 = "intranet2"

$vmSize = "Small"
$vnetName = "PSBookVNET"
$imageFamily = "Windows Server 2012 R2 Datacenter"

$imageName = Get-AzureVMImage |
                 where { $_.ImageFamily -eq $imageFamily } |
                 sort PublishedDate -Descending |
                 select -ExpandProperty ImageName -First 1

# Create a virtual machine configuration object
$vm1 = New-AzureVMConfig -Name $vmName1 -InstanceSize $vmSize -ImageName $imageName

$vm1 | Add-AzureProvisioningConfig -Windows `
                                   -AdminUsername $adminUser `
                                   -Password $password

$vm1 | Set-AzureSubnet -SubnetNames "AppSubnet"

$vm1 | Add-AzureEndpoint -Name "intranet" -Protocol tcp `
                         -LocalPort 80 -PublicPort 80 `
                         -LBSetName "lbintranet" `
                         -InternalLoadBalancerName "MyILB" `
                         -DefaultProbe

# Create a virtual machine configuration object
$vm2 = New-AzureVMConfig -Name $vmName2 -InstanceSize $vmSize -ImageName $imageName

$vm2 | Add-AzureProvisioningConfig -Windows `
                                   -AdminUsername $adminUser `
                                   -Password $password

$vm2 | Set-AzureSubnet -SubnetNames "AppSubnet"

$vm2 | Add-AzureEndpoint -Name "intranet" -Protocol tcp `
                         -LocalPort 80 -PublicPort 80 `
                         -LBSetName "lbintranet" `
                         -InternalLoadBalancerName "MyILB" `
                         -DefaultProbe

# Specify the internal load balancer configuration and the virtual network
New-AzureVM -ServiceName $serviceName `
            -Location $location `
            -VNetName $vnetName `
            -InternalLoadBalancerConfig $ilb `
            -VMs $vm1, $vm2