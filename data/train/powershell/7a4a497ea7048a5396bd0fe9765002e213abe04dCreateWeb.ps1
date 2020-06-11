function CreateWeb()
{
    Write-Status "Creating Web 0..."
    CreateWebVm $webServerName0 $webServerIP0

    Write-Status "Creating Web 1..."
    CreateWebVm $webServerName1 $webServerIP1

    Write-Status "Creating Web 2..."
    CreateWebVm $webServerName2 $webServerIP2

    Write-Status "Creating Web 3..."
    CreateWebVm $webServerName3 $webServerIP3

    Write-Status "Creating Web 4..."
    CreateWebVm $webServerName4 $webServerIP4

    Write-Status "Creating Web 5..."
    CreateWebVm $webServerName5 $webServerIP5
  
    Write-Status "Creating Web 6..."
    CreateWebVm $webServerName6 $webServerIP6

    Write-Status "Creating Web 7..."
    CreateWebVm $webServerName7 $webServerIP7

    Write-Status "Creating Web 8..."
    CreateWebVm $webServerName8 $webServerIP8

    # deployment master\slave drive
    Get-AzureVM -ServiceName $cloudServiceName -Name $webServerName0 |
        Add-AzureDataDisk -CreateNew -DiskSizeInGB 30 -DiskLabel "Deployment" -LUN 0 |
            Update-AzureVM

    # mkdir z:\buddyapps 
    # NET SHARE buddyapps=z:\ /GRANT:Everyone,FULL
}

function CreateWebVm($serverName, $IP)
{
    $installAspNetScriptBlock =
    {
        Install-WindowsFeature -Name Web-Asp-Net45, Web-Asp-Net, AS-NET-Framework, AS-Web-Support
    }
    
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $serverName

    if ($vm -eq $null)
    {
        $vm = GetWinVmConfig $cloudServiceName $serverName $Standard_A2 $webAvailabilitySetName $frontEndSubnetName $IP

        $vm | New-AzureVM `
					-ServiceName $cloudServiceName `
                    -WaitForBoot

        RunRemotely $vmAdminUser $vmAdminPassword $cloudServiceName $serverName $installAspNetScriptBlock

        RdpManageCert $cloudServiceName $serverName
    }
}