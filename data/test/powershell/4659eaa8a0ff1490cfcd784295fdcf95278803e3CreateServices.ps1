function CreateServices0()
{
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $servicesServerName0

    if ($vm -eq $null)
    {
        $vm = GetWinVmConfig $cloudServiceName $servicesServerName0 $Basic_A2 $servicesAvailabilitySetName $backEndSubnetName $servicesServerIP0
     
        $vm | New-AzureVM `
                -ServiceName $cloudServiceName `
                -Location $location `
                -VNetName $virtualNetworkName `
                -WaitForBoot

        RdpManageCert $cloudServiceName $servicesServerName0
    }
}

function CreateServices1()
{
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $servicesServerName1

    if ($vm -eq $null)
    {
        $vm = GetWinVmConfig $cloudServiceName $servicesServerName1 $Basic_A2 $servicesAvailabilitySetName $backEndSubnetName $servicesServerIP1

        $vm | New-AzureVM `
                    -ServiceName $cloudServiceName `
                                    -WaitForBoot

        RdpManageCert $cloudServiceName $servicesServerName1
    }
}