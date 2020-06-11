param([string]$path = "..\..\..\")

function HasBooleanValue($entry)
{       
    if($entry) {
        $TrimedEntry = $entry.ToLower().Trim();
        return ($TrimedEntry -eq "true" -or $TrimedEntry -eq "false");           
    }
    
    return $FALSE;
}

function HasStringValue($entry)
{
    return ($entry); 
}

function HasPlaceholder($entry)
{
	return ($entry.StartsWith('{'));
}

function WriteMessage($message, $showError)
{
	if ($showError)
	{
		Write-Host "  ERROR: " $message;
		$script:errorsCount = $script:errorsCount + 1; 
	}
	else
	{
		Write-Host "  WARNING: " $message;
		$script:warningsCount = $script:warningsCount + 1;
	}
}

function CheckEmptyOrPlaceholder($entryName, $entryValue)
{
	CheckEmptyOrPlaceholder $entryName $entryValue $false;
}

function CheckEmptyOrPlaceholder($entryName, $entryValue, $showError)
{
    if(-not (HasStringValue($entryValue))) 
	{
		WriteMessage "$entryName cannot be empty" $showError;
	}
	elseif (HasPlaceholder($entryValue)) 
	{
		WriteMessage "$entryName should be configured" $showError;
	}
}

function CheckShouldBeEmpty($entryName, $entryValue)
{
	CheckShouldBeEmpty $entryName $entryValue $false;
}

function CheckShouldBeEmpty($entryName, $entryValue, $showError)
{
    if(-not ($entryValue -eq $null)) 
	{
		WriteMessage "$entryName should be empty" $showError;
	}
}

function CheckBooleanOrPlaceholder($entryName, $entryValue)
{
	CheckBooleanOrPlaceholder $entryName $entryValue $false;
}

function CheckBooleanOrPlaceholder($entryName, $entryValue, $showError)
{
    if(-not (HasBooleanValue($entryValue))) 
	{
		WriteMessage "$entryName should be true or false" $showError;
	}
	elseif (HasPlaceholder($entryValue)) 
	{
		WriteMessage "$entryName should be configured" $showError;
	}
}

function CheckPlaceholder($entryName, $entryValue)
{
	CheckPlaceHolder $entryName $entryValue $false;
}

function CheckPlaceholder($entryName, $entryValue, $showError)
{
	if (HasPlaceholder($entryValue)) 
	{
		WriteMessage "$entryName should be configured or left blank" $showError;
	}
}

function CheckLocalDataBaseSettings()
{
	Write-Host "Verifying Database settings for local compute emulator ...";
	
	CheckPlaceholder "Database/ServerName" $xml.Configuration.Database.ServerName;
	CheckEmptyOrPlaceholder "Database/DatabaseName" $xml.Configuration.Database.DatabaseName $true;
}

function CheckAzureDataBaseSettings()
{
	Write-Host "Verifying Database settings ...";

	if (-not (HasStringValue($xml.Configuration.Database.ServerName)))
	{
		#server will be created
		CheckPlaceholder "Database/Location" $xml.Configuration.Database.Location $true;
	}

	CheckEmptyOrPlaceholder "Database/DatabaseName" $xml.Configuration.Database.DatabaseName $true;
	CheckEmptyOrPlaceholder "Database/Username" $xml.Configuration.Database.Username $true;
	CheckEmptyOrPlaceholder "Database/Password" $xml.Configuration.Database.Password $true;
}

function CheckAcsSettings()
{
	Write-Host "Verifying AccessControlService settings ...";

	CheckEmptyOrPlaceholder "AccessControlService/Namespace" $xml.Configuration.AccessControlService.Namespace $true;
	CheckEmptyOrPlaceholder "AccessControlService/ManagementKey" $xml.Configuration.AccessControlService.ManagementKey $true;
	CheckEmptyOrPlaceholder "AccessControlService/RelyingPartyRealm" $xml.Configuration.AccessControlService.RelyingPartyRealm $true;
	CheckBooleanOrPlaceholder "AccessControlService/UseWindowsLiveIdentityProvider" $xml.Configuration.AccessControlService.UseWindowsLiveIdentityProvider $true;
	CheckBooleanOrPlaceholder "AccessControlService/UseFacebookIdentityProvider" $xml.Configuration.AccessControlService.UseFacebookIdentityProvider $true;
    
	if (HasBooleanValue($xml.Configuration.AccessControlService.UseFacebookIdentityProvider))
	{
		$UseFacebookIdentityProvider = [System.Convert]::ToBoolean($xml.Configuration.AccessControlService.UseFacebookIdentityProvider.ToLower());
	    if($UseFacebookIdentityProvider) 
		{
			CheckEmptyOrPlaceholder "AccessControlService/FacebookApplicationId" $xml.Configuration.AccessControlService.FacebookApplicationId $true;
			CheckEmptyOrPlaceholder "AccessControlService/FacebookApplicationName" $xml.Configuration.AccessControlService.FacebookApplicationName $true;
			CheckEmptyOrPlaceholder "AccessControlService/FacebookSecret" $xml.Configuration.AccessControlService.FacebookSecret $true;
	    }
	}
}

function CheckStorage()
{
	Write-Host "Verifying WindowsAzureStorage settings ...";

	CheckEmptyOrPlaceholder "WindowsAzureStorage/StorageAccountName" $xml.Configuration.WindowsAzureStorage.StorageAccountName $true;
	CheckPlaceholder "WindowsAzureStorage/StorageAccountKey" $xml.Configuration.WindowsAzureStorage.StorageAccountKey;
	CheckPlaceholder "WindowsAzureStorage/StorageAccountLocation" $xml.Configuration.WindowsAzureStorage.StorageAccountLocation;
	CheckPlaceholder "WindowsAzureStorage/StorageAccountLabel" $xml.Configuration.WindowsAzureStorage.StorageAccountLabel;
}

function CheckDeployment()
{
	Write-Host "Verifying Deployment settings ...";

	CheckEmptyOrPlaceholder "deployment/packageFile" $xml.Configuration.deployment.packageFile;
	CheckEmptyOrPlaceholder "deployment/configurationFile" $xml.Configuration.deployment.configurationFile;
	CheckEmptyOrPlaceholder "deployment/label" $xml.Configuration.deployment.label;
}

function CheckHostedService()
{
	Write-Host "Verifying HostedService settings ...";
	
	CheckEmptyOrPlaceholder "hostedService/name" $xml.Configuration.hostedService.name $true;
	CheckPlaceholder "hostedService/label" $xml.Configuration.hostedService.label;
	CheckPlaceholder "hostedService/location" $xml.Configuration.hostedService.location;
}

function CheckAzureSettings()
{
	Write-Host "Verifying azure settings ...";
	
	CheckEmptyOrPlaceholder "subscriptionId" $xml.Configuration.subscriptionId $true;
	CheckEmptyOrPlaceholder "managementCertificateThumbprint" $xml.Configuration.managementCertificateThumbprint $true;
}

function ValidateConfiguration($configurationFilePath)
{   
    [xml]$xml = Get-Content $configurationFilePath;                 
    
	CheckBooleanOrPlaceholder "UseLocalComputeEmulator" $xml.Configuration.UseLocalComputeEmulator;
	
    $UseLocalComputeEmulator = [System.Convert]::ToBoolean($xml.Configuration.UseLocalComputeEmulator.ToLower());
	
	if ($UseLocalComputeEmulator)
	{
		CheckLocalDataBaseSettings;
	}
	else
	{
		CheckAzureDataBaseSettings;
		CheckAcsSettings;
		CheckStorage;
		CheckHostedService;
		CheckAzureSettings;
		CheckDeployment;
	}
}

$configurationFilePath = "$path\Configuration.xml";

Write-Host "Verifying configuration file: Configuration.xml";
	
$errorsCount = 0;
$warningsCount = 0;

ValidateConfiguration $configurationFilePath;

if($errorsCount -eq 0 -and $warningsCount -eq 0)
{
    exit 0;
}    
else
{
	if ($errorsCount -gt 0)
	{
    	exit 1;
	}
	else
	{
    	exit 2;
	}
}
