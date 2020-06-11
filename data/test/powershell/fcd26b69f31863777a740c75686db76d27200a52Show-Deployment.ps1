param(	
		[switch]$clean,																					# Clean up any pre-existing installations first
		[switch]$dBClean,																				# 
		[switch]$appClean,																				# 
		[switch]$dbOnly,																				# Just deploy the databases
		[switch]$dbPatch,																				# Patch the database with the deploy manifest files.
		[switch]$dbInit,																				# Prepares the platform for first use.
		[switch]$verbose,																				# Verbose screen logging
		[switch]$debug,																					# Apply DebugPreferences to Powershell
		[object]$userIdentity 
	)
	
	$deploymentManifest = (@($input)[0])
	$tfExe = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\TF.exe"
	
	$exe_dirname = (Join-Path $deploymentManifest.buildDefinition.artefactsRoot "..\Deploy")
	. "$($exe_dirname)\Helpers\DeploymentHelper.ps1"

	function printHostBanner($banner)
	{
		write-host "`n`n$banner"	
		write-host ("*" * $banner.length)
	}
	
	$isProduction = [bool]$deploymentManifest.targetEnvironment.environment_config.switches.isProduction;

	if ($deploymentManifest.targetEnvironment.environment_config.switches.deploymentGroup -gt 0 )
	{
		Write-Warning "Start-Deployment.ps1 -> Using Deployment Group $($deploymentManifest.targetEnvironment.environment_config.switches.deploymentGroup)"
			
		$targetGroup = [int]$deploymentManifest.targetEnvironment.environment_config.switches.deploymentGroup;
		Write-Warning "Start-Deployment.ps1 -> Deployment group attribute has been set to $targetGroup"
			
		$groupJobs = @();
		$groupServers = @();
			
		foreach ($appJob in $deploymentManifest.appJobs)
		{
			$targetServer = $appJob.webServer
			
			if ($targetServer.deploymentGroup -eq $targetGroup)
			{
				Write-Warning "Start-Deployment.ps1 -> $($appJob.jobName)@$($targetServer.logicalName) was approved"
				$groupJobs += $appJob
					
				if (($groupServers | where {$_.logicalName -eq $targetServer.logicalName}) -eq $null)
				{
					$groupServers += $targetServer
				}
			}
			else
			{
				# Write-Warning "Start-Deployment.ps1 -> $($appJob.jobName)@$($targetServer.logicalName) removed from deployment manifest"
			}
		}
			
		# Reset the application jobs list to those filtered for deployment group servers
		$deploymentManifest.appJobs = ($groupJobs | ToArray);
			
		# Extract only the servers matching deployment group
		$deploymentManifest.targetEnvironment.server_farm.servers = ($groupServers | ToArray)
		$deploymentManifest.targetEnvironment.server_farm.servers | % {
			Write-Warning "Start-Deployment.ps1 -> Server $($_.logicalName) will be targeted."
		}
	}

	
	printHostBanner "Show Deployment"

	if ($deploymentManifest.length -eq 0) {
		Write-Host "Please supply a deployment manfiest via Get-Packages.ps1 | Publish-Build.ps1`n`n"
		exit;
	}

	$currentBuild = 0;
	$currentPlatform = "";
	
	if (!($isProduction))
	{
		$serviceEndpoints = GenerateServiceMap $deploymentManifest
		
		$serviceEndpoints | % {
			Write-Host ("{0,-50} -> {1}" -f $_.key, $_.host)
		}
	
		printHostBanner "Infrastructure Map"

		$deploymentManifest.targetEnvironment.server_farm.servers | % {
			write-host ("{0} [{1}]" -f $_.dnsName,($_.role -join ","))
		
			$tokenFile = ("\\{0}\C$\Temp\Deployment-token.txt" -f  $_.dnsName)

			if (Test-Path $tokenFile)
			{
				$token = Get-Content ("\\{0}\C$\Temp\Deployment-token.txt" -f  $_.dnsName)
				$token = $token.Split("|");

				$currentBuild = $token[1]
				$currentPlatform = $token[0]
			}
		}

		printHostBanner ("{0,-20}{1,-29}{2,-5}" -f "Platform Details","Branch","Build")

		Write-Host ("Currently hosting : {0,-25}@ b {1}" -f $currentPlatform,$currentBuild) -fore yellow
		Write-Host ("Target build      : {0,-25}@ b {1}" -f $deploymentManifest.buildDefinition.buildDefinition,$deploymentManifest.buildDefinition.buildId) -fore yellow
		
		$tfsAddress = "$/Silo18/";
		if ($deploymentManifest.buildDefinition.buildDefinition -match "Main_CI|UI-Only")
		{
			$tfsAddress = ("$/Silo18/{0}" -f "Main")
		}
		else
		{
			$tfsAddress = ("$/Silo18/Sprints/{0}" -f $deploymentManifest.buildDefinition.buildDefinition)
		}

		if ($currentPlatform -eq $deploymentManifest.buildDefinition.buildDefinition -and ($currentBuild -ne $deploymentManifest.buildDefinition.buildId))
		{
			printHostBanner "Upgrade Information"

			$labelRange = ("L{0}~L{1}" -f $currentBuild,$deploymentManifest.buildDefinition.buildId)
			$tfsAddress
			$labelRange 
			& $tfExe history /server:http://bgotfs01:8080/tfs/defaultcollection $tfsAddress /version:$($labelRange) /recursive /noprompt  
		}
	}
	
	
	if (Test-Path $deploymentManifest.targetEnvironment.environment_config.deploymentRegister)
    {
		printHostBanner "Existing Installation Details"

        $deploymentRegister = Import-Clixml  $deploymentManifest.targetEnvironment.environment_config.deploymentRegister

		printHostBanner ("{0,-70} {1,-30} {2,-6}+ {5,-12}  | {3,-10} by {4}" -f "Project",  "Branch", "Build", "Server", "Who", "NuGet" )

		$deploymentRegister.GetEnumerator() | 
			Sort-Object { $_.Value.build, $_.Key  }  -Descending  | 
			ForEach-Object {  Write-Host ("{0,-70} {1,-30} {2,-6}+ {5,-12}  | {3,-10} by {4}" -f $_.Key,  $_.Value.branch, $_.Value.build,  $_.Value.server, $_.Value.deployedBy, $_.Value.frameworkVersion ) }
    }

	printHostBanner "Package Manifest"
	Write-Host "`n`nA total of $($deploymentManifest.appJobs.length+$deploymentManifest.dbJobs.length) packages will be deployed." 
	
	$deploymentManifest.targetEnvironment.server_farm.servers | % {
	
		$targetServer = $_;

		printHostBanner ("{0,-80}{1,-20}{2,-20}" -f $targetServer.dnsName,"Manage IIS","Sequential Candidate")

		foreach ($job in @() + $deploymentManifest.appJobs + $deploymentManifest.dbJobs | ? {$_.webServer.dnsName -eq $targetServer.dnsName})
		{
			$colour = "green"

			if ([bool]$job.application.groupedSequential)
			{
				$regexPattern = "(\w{1,})(?:[0-9])" #Remove the uniqueID from the jobID
				$commonGroupName = $job.jobName -replace $regexPattern,'$1'

				$sequential = (($deploymentManifest.appJobs | ? {$_.jobName.StartsWith($commonGroupName) -and $_.jobName -ne $job.jobName}) -ne $null)
			}

			if ($sequential -or [bool]$job.application.manageServerConfig)
			{
				$colour = "yellow"
			}

			if ([bool]$job.application.isProduction)
			{
				$color = "red"
			}
			
			Write-Host ("{0,-80}{1,-20}{2,-20}" -f $job.jobName, [bool]$job.application.manageServerConfig, [bool]$sequential, [bool]$job.application.isProduction) -fore $colour
		}
	}

	if ($deploymentManifest.targetEnvironment.environment_config.switches.isProduction)
	{
			Write-Host "===============================================================================================================================================" -fore white -back red
			Write-Host "THIS IS A PRODUCTION ENVIRONMENT  -  THIS IS A PRODUCTION ENVIRONMENT  -  THIS IS A PRODUCTION ENVIRONMENT  -  THIS IS A PRODUCTION ENVIRONMENT" -fore white -back red
			Write-Host "===============================================================================================================================================" -fore white -back red

			Write-Host "Deployment Group $deploymentGroup" -fore red
	}
