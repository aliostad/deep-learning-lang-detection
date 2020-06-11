Import-Module ".\NewRelic.Lib.psm1" -force
$VerbosePreference = "Continue"

# Ensure API key is specified
if (! ($NewRelicAgentApiKey) ) {
	Write-Error "NewRelicApiKey must be defined!"
	exit 1;
}
# Setup application name
if(! ($NewRelicApplicationName)) {
	if(! ($OctopusProjectName)) {
		Write-Error "No octopus variables set"
		exit 1
	}
	Write-Host "NewrelicApplicationName not set - Setting to: $OctopusProjectName $OctopusEnvironmentName"
	$NewRelicApplicationName = "$OctopusProjectName $OctopusEnvironmentName"
}
else {
	Write-Host "NewrelicApplicationName set to: $NewrelicApplicationName"
}

#Install New Relic Server Monitor and Agent
Write-Host "Installing New Relic Server Monitor"
InstallNewRelicServerMonitor $NewRelicAgentApiKey
Write-Host "Installing New Relic .NET Agent"
InstallNewRelicAgent $NewRelicAgentApiKey $NewRelicApplicationName

if(!($NewRelicAutoRepair -eq "false")) {
    $repairScript = resolve-path ".\CreateScheduledTaskNewRelicRepair.ps1"
	& $repairScript | Write-Host
}
else {
	Write-Warning "NewRelicAutoRepair variable set to false. Auto repair will not be enabled."
}

#Reset IIS 
if($NewRelicIisReset -eq "true") {
	& "iisreset" | Write-Host
}
else {
	Write-Warning "NewRelicIisReset variable not set to true. Note IIS reset will not be performed automatically. Perform an IIS reset before the New Relic Agent will notice any changes!"
}

