#Internal function
Function Enable-AzdeAzureSubscription
{
    [Cmdletbinding()]
	Param ($SubscriptionId,$Storageaccountname)
	$Subs = get-azuresubscription | where {$_.SubscriptionId -eq $Subscriptionid}
	if (!($Subs))
	{
		throw "Azure subscription $Subscriptionid is not installed on this computer"
	}
	
	$CurrentSubs = get-azuresubscription -Current
	if ($CurrentSubs.SubscriptionId -ne $SubscriptionId)
	{
		Write-enhancedVerbose -MinimumVerboseLevel 2 -Message "Switching to azure subscription $SubscriptionId"
		$Subs | Select-azuresubscription -current
		$CurrentSubs = $Subs
	}
	Else
	{
		Write-enhancedVerbose -MinimumVerboseLevel 2 -Message "Already on the correct azure subscription"
	}

    if ($Storageaccountname)
    {
        if ($CurrentSubs.CurrentStorageAccount -ne $Storageaccountname)
        {
            Write-enhancedVerbose -MinimumVerboseLevel 2 -Message "Setting correct storage account name ($storageaccountname) for subscription $subscriptionid"
            Set-AzureSubscription -subscriptionname ($CurrentSubs.SubscriptionName) -CurrentStorageAccountName ($Storageaccountname.ToLower())
        }
    }

    #Test that we can connect
    try
    {
        Get-azurevm -ErrorAction Stop | out-null
    }
    catch
    {
        $connecterr = $_
    }

    if ($connecterr.Exception.Message -match "Please use Add-AzureAccount to login again")
    {
        throw $connecterr.Exception.Message
    }
}

