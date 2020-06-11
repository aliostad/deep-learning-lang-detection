Add-AzureAccount
Select-AzureSubscription "Windows Azure MSDN - Visual Studio Ultimate"
Get-AzureWebsite | Where {$_.Name -notin $websitesToSave} | Remove-AzureWebsite -Force
Get-AzureService | Where {$_.Label -notin $VMsToSave} | Remove-AzureService -Force
Get-AzureDisk | Where {$_.AttachedTo -eq $null} | Remove-AzureDisk -DeleteVHD
Get-AzureStorageAccount | Where {$_.Label -notin $storageAccountsToSave} | Remove-AzureStorageAccount
Get-AzureAffinityGroup | Remove-AzureAffinityGroup
Remove-AzureVNetConfig