# Azure Cmdlet Reference
# http://msdn.microsoft.com/library/azure/jj554330.aspx

$subscriptionId     = "<enter your subscription ID here>"
$imageLabel         = "Ubuntu Server 14.04 LTS"       # One from Get-AzureVMImage | select Label
$datacenter         = "West Europe"
$adminuser          = "azureuser" #or whatever you prefer
$adminpass          = "<enter your password here>"
$instanceSize       = "Medium" # ExtraSmall,Small,Medium,Large,ExtraLarge,A5,A6,A7,A8,A9,Basic_A0,Basic_A1,Basic_A2,Basic_A3,Basic_A4
$storageAccountName = "<enter your storage account here>"
$affinitygroup      = "<enter your affinity group here>"
$vnetname           = "<enter your vnet name here>"
$subnetname         = "<enter your subnet name here>" 
# and make sure the IPs selected are part of this subnet

$loadBalancerName   = "galera-ilb"
$loadBalancerIP     = "10.11.0.10"

$servicename        = "<enter your service name here>"
$availabilityset    = "galera-as"

#
# Calculate a bunch of properties
#
$subscriptionName = (Get-AzureSubscription | `
	select SubscriptionName, SubscriptionId | `
	Where-Object SubscriptionId -eq $subscriptionId | `
	Select-Object SubscriptionName)[0].SubscriptionName

Select-AzureSubscription -SubscriptionName $subscriptionName -Current
 
$imageName = (Get-AzureVMImage | Where Label -eq $imageLabel | Sort-Object -Descending PublishedDate)[0].ImageName
 
#$storageAccount = (Get-AzureStorageAccount | `
#	Where-Object Location -eq $datacenter)[0]
  
$storageAccountKey = (Get-AzureStorageKey -StorageAccountName $storageAccountName).Primary
 
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

#
# Fix the local subscription object
#
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount $storageAccountName 



Function Get-CustomVM
{
    Param (
        [string]$customVmName, 
        [string]$machineIpAddress, 
        [int]$externalSshPortNumber,
        [string] $storageAccountName = $storageContext.StorageAccountName
        )

    # 
    # configure the VM object
    #
    $vm = New-AzureVMConfig `
		    -Name $customVmName `
		    -InstanceSize $instanceSize `
		    -ImageName $imageName `
            -AvailabilitySetName $availabilityset `
		    -MediaLocation "https://$storageAccountName.blob.core.windows.net/vhds/$customVmName-OSDisk.vhd" `
		    -HostCaching "ReadOnly" `
            | `
	    Add-AzureProvisioningConfig `
		    -Linux `
		    -LinuxUser $adminuser `
		    -Password $adminpass `
            | `
        Set-AzureSubnet -SubnetNames $subnetname `
            | `
        Set-AzureStaticVNetIP -IPAddress $machineIpAddress `
            | `
        Remove-AzureEndpoint `
            -Name SSH `
            | `
	    Add-AzureEndpoint `
		    -Name SSH `
		    -LocalPort 22 `
		    -PublicPort $externalSshPortNumber `
		    -Protocol tcp `
            |`
	    Add-AzureEndpoint `
		    -Name mysql `
		    -LocalPort 3306 `
		    -PublicPort 3306 `
            -InternalLoadBalancerName $loadBalancerName `
		    -Protocol tcp `
            -ProbePort 3306 `
            -ProbeProtocol "tcp" `
            -ProbeIntervalInSeconds 5 `
            -ProbeTimeoutInSeconds 11 `
            -LBSetName mysql
 
    $vm
}

#
# 0. Create cloud service before instantiating internal load balancer
#
if ((Get-AzureService | where ServiceName -eq $servicename) -eq $null) {
    Write-Host "Create cloud service"
    New-AzureService -ServiceName $servicename -Location $datacenter
}

#
# 1. Create a dummyVM with an external endpoint so that the internal load balancer (which is in preview) is willing to be created
#
$dummyVM = New-AzureVMConfig -Name "placeholder" -InstanceSize ExtraSmall -ImageName $imageName `
    -MediaLocation "https://$storageAccountName.blob.core.windows.net/vhds/dummy-OSDisk.vhd" -HostCaching "ReadWrite" `
    | Add-AzureProvisioningConfig -Linux -LinuxUser $adminuser -Password $adminpass `
    | Set-AzureSubnet -SubnetNames $subnetname `
    | Set-AzureStaticVNetIP -IPAddress "10.0.1.200" 

New-AzureVM -ServiceName $servicename -VNetName $vnetname -VMs $dummyVM 

#
# 2. Create the internal load balancer (no endpoints yet)
#
Add-AzureInternalLoadBalancer -ServiceName $servicename -InternalLoadBalancerName $loadBalancerName –SubnetName $subnetname –StaticVNetIPAddress $loadBalancerIP
if ((Get-AzureInternalLoadBalancer -ServiceName $servicename) -ne $null) {
    Write-Host "Created load balancer"
}

#
# 3. Create the cluster machines and hook them up to the ILB (without mentioning "-Location $datacenter -VNetName $vnetname ", because the $dummyVM pinned these already
#
$vm1 = Get-CustomVM -customVmName "galera-a" -machineIpAddress "10.11.0.11" -externalSshPortNumber 40011
$vm2 = Get-CustomVM -customVmName "galera-b" -machineIpAddress "10.11.0.12" -externalSshPortNumber 40012
$vm3 = Get-CustomVM -customVmName "galera-c" -machineIpAddress "10.11.0.13" -externalSshPortNumber 40013
New-AzureVM -ServiceName $servicename -VMs $vm1,$vm2,$vm3

#
# 4. Delete the dummyVM
#
Remove-AzureVM -ServiceName $servicename -Name $dummyVM.RoleName -DeleteVHD

