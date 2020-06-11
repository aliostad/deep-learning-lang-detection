<#
    MIT License

    Copyright (c) 2017 Oliver Lohmann

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>

<#
    .SYNOPSIS
        Import an external VHD file to a subscription-local storage account via an asynchronous copy task.
    .EXAMPLE
        .\Import-ExternalVhdToAzureRmBlobStorage.ps1 -SrcImageUrl 'https://...blob.core.windows.net/.../abcd?sv=...&sr=...&si=....' -ResourceGroupName 'my-rg' -StorageAccountName 'mystacc2921' -ContainerName 'mycontainer' -BlobName 'mydisk.vhd'
#>

Param(
    [Parameter(Mandatory = $true, HelpMessage = "Source URL (including a SAS token if authentication is required)")]
    [string]$SrcImageUrl,
    
    [Parameter(Mandatory = $true, HelpMessage = "Name of the Resource Group that contains the target storage account.")]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true, HelpMessage = "Name of the target Storage Account.")]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $true, HelpMessage = "Name of the target Container Name.")]
    [string]$ContainerName,

    [Parameter(Mandatory = $true, HelpMessage = "Name of the target Blob Name.")]
    [string]$BlobName
)

Try {
    $ctx = Get-AzureRmContext
}
Catch {
    if ($_ -like "*Login-AzureRmAccount to login*") {
        throw "Please login before executing this script: Login-AzureRmAccount"
    }
}

$storageAccount = Get-AzureRmStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName
$keys = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $keys[0].Value


$storageContainer = $null
$storageContainerExists = $true
try {
    $storageContainer = Get-AzureStorageContainer -Name $ContainerName -Context $storageContext -ErrorAction Stop
} catch {
    if ($_.Exception.Message -like "*Can not find the container*") {
        $storageContainerExists = $false
    } else {
        throw $_.Exception
    }
}

if ($storageContainerExists) {
    Write-Host "Using existing container $ContainerName." -ForegroundColor Green
} else {
    Write-Host "Creating new container $ContainerName." -ForegroundColor Yellow
    $storageContainer = New-AzureStorageContainer -Name $ContainerName -Context $storageContext -ErrorAction Stop
}

Write-Host "Starting async copy job (can take several minutes to finish)..." 
$copyStatus = $null
$blobCopy = Start-AzureStorageBlobCopy -SrcUri $SrcImageUrl -DestContainer $storageContainer.Name -DestContext $storageContext -DestBlob $BlobName -ErrorAction Stop
$copyStatus = $blobCopy | Get-AzureStorageBlobCopyState 

While ($copyStatus.Status -eq "Pending") {
  $copyStatus = $blobCopy | Get-AzureStorageBlobCopyState 
  Start-Sleep 5
  $gbCopied = $copyStatus.BytesCopied / 1024.0 / 1024.0 / 1024.0
  $gbLeft = $copyStatus.TotalBytes / 1024.0 / 1024.0 / 1024.0
  Write-Progress -Activity "Copying..." -CurrentOperation "Copied $gbCopied GB of $gbLeft GB" -PercentComplete ($copyStatus.BytesCopied / $copyStatus.TotalBytes * 100)
}

if ($copyStatus -ne $null) {
  Write-Host "Finished with Status: $($copyStatus.Status)"
}
