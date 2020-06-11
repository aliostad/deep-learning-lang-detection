<#
.SYNOPSIS
   Copy all Virtual Hard Disks (VHD's) from the current subscription to a different 
   subscription.
.DESCRIPTION
   Start's an asynchronous copy of VHD's to a different subscription and storage account.
.EXAMPLE
   .\CopyAllVhdBetweenSubscription.ps1 
         -DestContainerName "DestinationContainerName" 
         -DestStorageAccountName "DestinationStorageAccount" 
         -DestStorageAccountKey "DestinationStorageKey"
#>
param 
(
    # Destination Storage Container name 
    [Parameter(Mandatory = $true)]
    [String]$DestContainerName,

    # Destination Storage Account name 
    [Parameter(Mandatory = $true)]
    [String]$DestStorageAccountName,

    # Destination Storage Account Key 
    [Parameter(Mandatory = $true)]
    [String]$DestStorageAccountKey)

# The script has been tested on Powershell 3.0
Set-StrictMode -Version 3

# Following modifies the Write-Verbose behavior to turn the messages on globally for this session
$VerbosePreference = "Continue"

# Check if Windows Azure Powershell is avaiable
if ((Get-Module -ListAvailable Azure) -eq $null)
{
    throw "Windows Azure Powershell not found! Please install from http://www.windowsazure.com/en-us/downloads/#cmd-line-tools"
}

# Get a collection of all disks.
$azureDisks = Get-AzureDisk

$tempStorageContainerAccounts = @{}
# Copy each VHD in the current storage account to a temporary container.
$tempStorageContainerName = "pstmp" + [DateTime]::UtcNow.Ticks
$tempCopyStates = @()
foreach ($azureDisk in $azureDisks)
{
    $src = $azureDisk.MediaLink
    $vhdName = $azureDisk.MediaLink.Segments | Where-Object { $_ -like "*.vhd" }

    if ($vhdName -ne $null)
    {
        $srcStorageAccount = $src.Host.Replace(".blob.core.windows.net", "") 
        $srcStorageAccountKey = (Get-AzureStorageKey -StorageAccountName $srcStorageAccount).Primary

        $srcContext = New-AzureStorageContext -StorageAccountName $srcStorageAccount -StorageAccountKey $srcStorageAccountKey
        if ((Get-AzureStorageContainer -Name $tempStorageContainerName -Context $srcContext -ErrorAction SilentlyContinue) -eq $null)
        {
            Write-Verbose "Creating container '$tempStorageContainerName'."
            New-AzureStorageContainer -Name $tempStorageContainerName -Context $srcContext
        }

        # Schedule a blob copy operation
        $tempCopyState = Start-AzureStorageBlobCopy -Context $srcContext -SrcUri $src `
                             -DestContext $srcContext -DestContainer $tempStorageContainerName `
                             -DestBlob $vhdName 
        $tempCopyStates += $tempCopyState

        # Add the storage account and context to a hash table so 
        # these can be removed at the end.
        if (($tempStorageContainerAccounts[$srcStorageAccount]) -eq $null)
        {
            $tempStorageContainerAccounts[$srcStorageAccount] = $srcContext
        }
    }
}

# Wait for all copy operations to temporary container to complete
# These copies should be instantaneous since they are in the same data center.
foreach ($copyState in $tempCopyStates)
{
    # Show copy status.
    $copyState | 
        Get-AzureStorageBlobCopyState -WaitForComplete | 
            Format-Table -AutoSize -Property Status,BytesCopied,TotalBytes,Source
}


# Make sure destination container exists. Create if it does not.
$destContext = New-AzureStorageContext –StorageAccountName $DestStorageAccountName  -StorageAccountKey $DestStorageAccountKey
if ((Get-AzureStorageContainer -Name $DestContainerName -Context $destContext -ErrorAction SilentlyContinue) -eq $null)
{
    Write-Verbose ("Creating container '{0}' in destination storage account '{1}'." -f $DestContainerName, $DestStorageAccountName)
    New-AzureStorageContainer -Name $DestContainerName -Context $destContext
}

# Copy blobs to destination storage account.
$destCopyStates = @()
foreach ($item in $tempStorageContainerAccounts.GetEnumerator())
{
    $srcContext = $item.Value
    Get-AzureStorageBlob -Container $tempStorageContainerName -Context $srcContext |
        ForEach-Object {
            $blob = $_
            $blobUri = $_.ICloudBlob.Container.Uri.AbsoluteUri + "/" + ($blob.Name)

            # Schedule a blob copy operation to the destination account.
            $destCopyState = Start-AzureStorageBlobCopy -Context $srcContext -SrcUri $blobUri `
                                 -DestContext $destContext -DestContainer $DestContainerName `
                                 -DestBlob $blob.Name -Force
            $destCopyStates += $destCopyState
        }
}

# Show the status of each blob copy operation.
# This could take a while if copying across data centers.
$delaySeconds = 10
do
{
    Write-Verbose "Checking storage blob copy status every $delaySeconds seconds."
    Write-Verbose "This will repeat until all copy operations are complete."
    Write-Verbose "Press Ctrl-C anytime to stop checking status."
    Write-Warning "If you do press Ctrl-C, manually remove temporary container '$tempStorageContainerName' from your storage accounts after the copy operation completes."
    Start-Sleep $delaySeconds

    $continue = $false

    foreach ($copyState in $destCopyStates)
    {
        # Check the copy state for each blob.
        $copyStatus = $copyState | Get-AzureStorageBlobCopyState
        $copyStatus | Format-Table -AutoSize -Property Status,BytesCopied,TotalBytes,Source

        # Continue checking status as long as at least one operations is still pending.
        if (!$continue)
        {
            $continue = $copyStatus -eq [Microsoft.WindowsAzure.Storage.Blob.CopyStatus]::Pending
        }
    }
} while ($continue)


# Remove temporary storage containers
foreach ($item in $tempStorageContainerAccounts.GetEnumerator())
{
    Write-Verbose ("Removing container '{0}' from storage account '{1}'." -f $tempStorageContainerName, $item.Key)
    Remove-AzureStorageContainer -Name $tempStorageContainerName -Context ($item.Value) -Force
}


