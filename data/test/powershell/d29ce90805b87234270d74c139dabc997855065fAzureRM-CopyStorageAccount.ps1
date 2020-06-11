$SourceStorageAccountName = Get-AutomationVariable "CopySourceStorageAccountName"
$SourceStorageAccountKey = Get-AutomationVariable "CopySourceStorageAccountKey"
$DestStorageAccountName = Get-AutomationVariable "CopyDestStorageAccountName"
$DestStorageAccountKey = Get-AutomationVariable "CopyDestStorageAccountKey"
$ContainerName = Get-AutomationVariable "CopyContainerName"

$SourceContext = New-AzureStorageContext -StorageAccountName $SourceStorageAccountName -StorageAccountKey $sourceStorageAccountKey
$DestinationContext = New-AzureStorageContext -StorageAccountName $DestStorageAccountName -StorageAccountKey $destStorageAccountKey 

$Blob = Get-AzureStorageBlob -Context $sourceContext -Container $ContainerName

$Blob | Start-AzureStorageBlobCopy -Context $sourceContext -DestContext $destinationContext -DestContainer $ContainerName -Force