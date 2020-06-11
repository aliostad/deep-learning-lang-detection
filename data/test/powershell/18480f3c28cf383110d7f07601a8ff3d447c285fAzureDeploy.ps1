# http://msdn.microsoft.com/en-us/library/windowsazure/dn495131.aspx

function main($arguments) {
	$exitCode = 0;
	$pwd = Get-Location
	write-host Current Working Folder $pwd

	$a = handleArgs($arguments);
	$DeployModel = $null
	$SubscriptionName = $null;
	$Location = $null;
	$WorkerRolePackage = $null;
	$WorkerRoleConfig = $null;
	$Slot = $null;
	$WorkerRoleName = $null;
	$PublishSettingsFile = $null;

	if($a.contains("DeployModel")) { $DeployModel = $a["DeployModel"]; }
	if($a.contains("SubscriptionName")) { $SubscriptionName = $a["SubscriptionName"]; }
	if($a.contains("Location")) { $Location = $a["Location"]; }
	if($a.contains("WorkerRolePackage")) { $WorkerRolePackage = $a["WorkerRolePackage"]; }
	if($a.contains("WorkerRoleConfig")) { $WorkerRoleConfig = $a["WorkerRoleConfig"]; }
	if($a.contains("Slot")) { $Slot = $a["Slot"]; }
	if($a.contains("WorkerRoleName")) { $WorkerRoleName = $a["WorkerRoleName"]; }
	if($a.contains("PublishSettingsFile")) { $PublishSettingsFile = $a["PublishSettingsFile"]; }

	if($DeployModel -eq "WorkerRole") {
		write-host Deploying worker role!
		return WorkerRole $SubscriptionName $Location $WorkerRolePackage $WorkerRoleConfig $Slot $WorkerRoleName $PublishSettingsFile;
	} else {
		$exitCode = 1;
	}

	return $exitCode;
}

function WorkerRole([string]$SubscriptionName, [string]$Location, [string]$WorkerRolePackage, [string]$WorkerRoleConfig, [string]$Slot, [string]$WorkerRoleName, [string]$PublishSettingsFile) {
	$exitCode = 0;
	write-host SubscriptionName = $SubscriptionName
	write-host Location = $Location
	write-host WorkerRolePackage = $WorkerRolePackage
	write-host WorkerRoleConfig = $WorkerRoleConfig
	write-host Slot = $Slot
	write-host WorkerRoleName = $WorkerRoleName
	write-host DeployModel = $DeployModel
	write-host PublishSettingsFile = $PublishSettingsFile
	


	Write-Host Azure publishing service.
	Write-Host Current working folder: $pwd

	Write-Host Importing Azure Publish Settings from $PublishSettingsFile
	# Download publish settings from: https://manage.windowsazure.com/publishsettings/index?client=powershell	
	Import-AzurePublishSettingsFile $PublishSettingsFile

	if ("$?" -eq "True") {
		Get-AzureSubscription
		if ("$?" -eq "True") {

			Write-Host Imported Azure Publish Settings
			Write-Host Setting AzureSubscription -SubscriptionName $SubscriptionName -CurrentStorageAccountName $WorkerRoleName
			#Parameter Set: CommonSettings
			#Set-AzureSubscription [-SubscriptionName] <String> [-Certificate <X509Certificate2> ] [-CurrentStorageAccountName <String> ] [-PassThru] [-ServiceEndpoint <String> ] [-SubscriptionDataFile <String> ] [-SubscriptionId <String> ] [ <CommonParameters>]

			Select-AzureSubscription -SubscriptionName $SubscriptionName -Current
			Set-AzureSubscription -SubscriptionName $SubscriptionName -CurrentStorageAccountName $WorkerRoleName 

			if ("$?" -eq "True") {

				#Parameter Set: Default
				#Get-AzureStorageAccount [[-StorageAccountName] <String> ] [ <CommonParameters>]
				Get-AzureStorageAccount -StorageAccountName $WorkerRoleName

				if ("$?" -eq "False") {
					# setting our storage account failed, lets force/create one, and then set it
					#Parameter Set: ParameterSetAffinityGroup
					#New-AzureStorageAccount [-StorageAccountName] <String> -AffinityGroup <String> [-Description <String> ] [-Label <String> ] [ <CommonParameters>]
					New-AzureStorageAccount -StorageAccountName $WorkerRoleName -Location $Location
				}


				Write-Host Attempting to get the current azure deployment -ServiceName $WorkerRoleName -Slot $Slot
				#Parameter Set: Default
				#Get-AzureDeployment [-ServiceName] <String> [[-Slot] <String> ] [ <CommonParameters>]
				Get-AzureDeployment -ServiceName $WorkerRoleName -Slot $Slot

				if ("$?" -eq "True") {
					Write-Host Received a valid azure deployment, $WorkerRoleName ($Slot) so it will be deleted
					#Parameter Set: Default
					#Remove-AzureDeployment [-ServiceName] <String> [-Slot] <String> [-Force] [ <CommonParameters>]
					Remove-AzureDeployment -ServiceName $WorkerRoleName -Slot $Slot -Force
				}

				Write-Host Attempting to get the Azure Service: $WorkerRoleName
				#Parameter Set: Default
				#Get-AzureService [[-ServiceName] <String> ] [ <CommonParameters>]
				Get-AzureService -ServiceName $WorkerRoleName
				if ("$?" -eq "False") {
					Write-Host Failed to get the Azure Service, lets create a new one now
					#Parameter Set: ParameterSetLocation
					#New-AzureService [-ServiceName] <String> [-Location] <String> [[-Label] <String> ] [[-Description] <String> ] [ <CommonParameters>]
					New-AzureService -ServiceName $WorkerRoleName -Location $Location
				}


				Write-Host Deploying a new Azure service: -ServiceName $WorkerRoleName -Slot $Slot ($WorkerRolePackage)
				#Parameter Set: PaaS
				#New-AzureDeployment [-ServiceName] <String> [-Package] <String> [-Configuration] <String> [-Slot] <String> [[-Label] <String> ] [[-Name] <String> ] [-DoNotStart] [-ExtensionConfiguration <ExtensionConfigurationInput[]> ] [-TreatWarningsAsError] [ <CommonParameters>]
				New-AzureDeployment -ServiceName $WorkerRoleName -Package $WorkerRolePackage -Configuration $WorkerRoleConfig -Slot $Slot -Name $WorkerRoleName
			}
			else
			{
				Write-Host Specified Subscription not found: $SubscriptionName 
				$exitCode = 4;
			}

		} else {
			Write-Host Error getting subscription.  Aborting!
			$exitCode = 3;
		}
	} else {
		Write-Host Error loading publish settings from disk.  Aborting!
		$exitCode = 2;
	}


}


function handleArgs($argList) {
	$arguments = @{}
	$counter = 0;
	foreach($a in $argList) {
		if($a -ne $null) {
			if( ($counter%2) -eq 0) {
				$name = $a;
				if($name.StartsWith("-") -eq "True") {
					$name = $name.Substring(1);
				}
				$name=$name.Trim();
			} else {
				if($a -is [int]) {
					$value = $a
				} else {
					$value = $a.Trim();	
				}				
				$arguments.Add($name, $value);
				$name = $null;
			}
		}
		$counter++;
	}
	return $arguments;
}


$a = $args
return main($a);
