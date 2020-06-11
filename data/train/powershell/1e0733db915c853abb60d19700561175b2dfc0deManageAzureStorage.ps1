#Creates Storage Account
function CreateStorageAccount($Name, $Location)
{
    $sAccount = Get-AzureStorageAccount | where { $_.StorageAccountName -eq $Name }
	if(!$sAccount)
	{
		# Create a new storage account
		LogMessage ("[Start] creating storage account {0} in location {1}" -f $Name, $Location)
		New-AzureStorageAccount -StorageAccountName $Name -Location $Location -Verbose
		LogMessage ("[Finish] creating storage account {0} in location {1}" -f $Name, $Location)
	}
	else
	{
		LogMessage ("Storage account '{0}' exists. New azure storage account hasn't been created" -f $Name)
	}
	# Get the access key of the storage account
	$key = Get-AzureStorageKey -StorageAccountName $Name 
	# Generate the connection string of the storage account
	$connectionString = "BlobEndpoint=http://{0}.blob.core.windows.net/;QueueEndpoint=http://{0}.queue.core.windows.net/;TableEndpoint=http://{0}.table.core.windows.net/;AccountName={0};AccountKey={1}" -f $Name, $key.Primary

	#this returns the storage key. example $storageData.AccessKey
	Return @{AccountName = $Name; AccessKey = $key.Primary; ConnectionString = $connectionString}		
}

#Removes Storage account
function RemoveStorageAccount($Name)
{
	LogMessage ("[Start] removing storage account {0}" -f $Name)
	$sAccount = Get-AzureStorageAccount | where { $_.StorageAccountName -eq $Name } 
	if($sAccount)
	{
		LogMessage ("[InProgress] storage account found {0}" -f $Name)
		$stat = Remove-AzureStorageAccount -StorageAccountName $Name
		if($stat.OperationStatus -eq "Succeeded")
		{
			LogMessage ("[Finish] removing storage account {0}" -f $Name)
		}
		else
		{
			LogMessage ("Removing storage account '{0}' failed" -f $Name)
		}
	}
	else
	{
		LogMessage ("Storage account '{0}' not found" -f $Name)
	}
}