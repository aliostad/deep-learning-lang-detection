param([string[]] $servers, [string]$environment="", [string] $artifactBaseFolderPath ="C:\BusinessSafe\Artifacts\", [string] $baseDestinationDirectory = "C$\NServiceBusServerEndpoints")
$ErrorActionPreference = "Stop";

<# To install
 
C:\NServiceBusServerEndpoints\BusinessSafeOnline\BusinessSafe.MessageHandlers\Published\NserviceBus.host.exe /install /servicename:BSOMH /displayName:"BusinessSafe message handlers service" /description:"Service for handling BusinessSafe messages" /username:"HQ\NServiceBus" /password:"Is74rb80pk52"

C:\NServiceBusServerEndpoints\BusinessSafeOnline\BusinessSafe.MessageHandlers.Emails\Published\NserviceBus.host.exe /install /servicename:BSOMHE /displayName:"BusinessSafe email service" /description:"Service for creating BusinessSafe emails" /username:"HQ\NServiceBus" /password:"Is74rb80pk52"

#>

<# to uninstall
C:\NServiceBusServerEndpoints\BusinessSafe.MessageHandlers\NserviceBus.host.exe /uninstall /servicename:BSOMH 

C:\NServiceBusServerEndpoints\BusinessSafe.MessageHandlers\NserviceBus.host.exe /uninstall /servicename:BSOMHE 


#>

if ($environment -eq "")
{
    throw "ERROR: environment parameter not set"
}

if ($server -eq "")
{
    throw "ERROR: server parameter not set"
}


# Folder Paths
$messageHandlersFolderPath = Join-Path  $artifactBaseFolderPath "BusinessSafe.MessageHandlers"
write-output "Message Handlers folder is : "  $messageHandlersFolderPath 

$emailMessageHandlersFolderPath = Join-Path  $artifactBaseFolderPath  "BusinessSafe.MessageHandlers.Emails"
write-output "Email Message Handlers folder is : "  $emailMessageHandlersFolderPath


#if destination is on another server then use c$\folder
function CopyFolder($source, $destination)
{
	if(test-path -path $destination)
	{
		Remove-Item $destination -Recurse -force
	}	
	Copy-Item $source $destination -recurse -force
}

function ReplaceAppConfigFile([string] $messageHandlerArtifactFolder, [string] $existingAppConfigFileName, [string] $environment)
{
	
	$sourceConfig = $messageHandlerArtifactFolder + "\Configs\App." + $environment + ".Transformed.config"
                $destinationConfigFolder = $messageHandlerArtifactFolder + "\Published"
                copy-item $sourceConfig $destinationConfigFolder -force

                $appConfigFileToRename = $destinationConfigFolder + "\App." + $environment + ".Transformed.config"
                $existingAppConfigFullPath = $destinationConfigFolder + "\" + $existingAppConfigFileName

				#Write-Host "existing $existingAppConfigFullPath. file to rename $appConfigFileToRename"
				if (Test-Path -Path $existingAppConfigFullPath )
				{
					Remove-Item $existingAppConfigFullPath 
					Start-Sleep -s 5
				}
				
                Rename-Item $appConfigFileToRename $existingAppConfigFileName -force
}

function DeployMessageHandlers([string] $server, [string] $baseDestinationDirectory, [string] $environment)
{
	# stop the service
	invoke-command $server {
    	Stop-Service -serviceName:BSOMH
	}

	$destination = "\\" + $server  + "\"  + $baseDestinationDirectory + "\BusinessSafe.MessageHandlers"
	
	# copy the artifact folder to the destination folder
	write-host "Deploying message handlers to $destination from $messageHandlersFolderPath for environment $environment"
	CopyFolder $messageHandlersFolderPath $destination

	ReplaceAppConfigFile $destination "BusinessSafe.MessageHandlers.dll.config" $environment
	
	# start the service
	invoke-command $server {
    	Start-Service -serviceName:BSOMH
	}
}

function DeployEmailMessageHandlers([string] $server, [string] $baseDestinationDirectory, [string] $environment)
{
	# stop the service
	invoke-command $server {
    	Stop-Service -serviceName:BSOMHE
	}
	
	$destination = "\\" + $server  + "\"  + $baseDestinationDirectory + "\BusinessSafe.MessageHandlers.Emails"
	
	# copy the artifact folder to the destination folder
	write-host "Deploying email message handlers to $destination from $emailMessageHandlersFolderPath for environment $environment"
	CopyFolder $emailMessageHandlersFolderPath $destination 
	
	ReplaceAppConfigFile $destination "BusinessSafe.MessageHandlers.Emails.dll.config" $environment
	
	# start the service
	invoke-command $server {
    	Start-Service -serviceName:BSOMHE
	}
}

function Execute-Command ($command, $numberOfRetries)
{
	$currentRetry = 0;
    $success = $false;
	do {
        try
        {
			& $Command;
			$success = $true;
        }
        catch [System.Exception]
        {
            if ($currentRetry -gt $numberOfRetries) {
                throw $_.Exception;
            } else {
				Write-Host  $_.Exception.ToString();
                Start-Sleep -s 2;
            }
            $currentRetry = $currentRetry + 1;
        }
    } while (!$success);
}

foreach($server in $servers)
{
	$command = {DeployMessageHandlers $server $baseDestinationDirectory $environment; }
	Execute-Command $command 1
	$command = {DeployEmailMessageHandlers $server $baseDestinationDirectory $environment; }
	Execute-Command $command 1
}

Write-Host "Deployment complete"