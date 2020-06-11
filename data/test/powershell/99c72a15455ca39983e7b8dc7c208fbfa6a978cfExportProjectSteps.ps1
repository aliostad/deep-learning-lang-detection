#
#
# This script exports all steps for a particular project to the packages.config file
# Usage: powershell -f ExportProjectSteps.ps1 -server "http://server:port" -project "Project Name" -userName "userName"
#
param (
	[string]$server = $(Read-Host "Server URL (http://myOctopusServer.com)"),
	[string]$project = $(Read-Host "Project Name"),
	[string]$apiKey = $null,
	[string]$outputFile = "packages.config",
	[string]$userName = $null
)

# Import required "modules"
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
Import-Module (Join-Path $ScriptDirectory Octopus/Octopus-Get.psm1)
Import-Module (Join-Path $ScriptDirectory Octopus/Octopus-Export.psm1)

if (($apiKey -eq $null) -or ($apiKey -eq ""))
{
	$apiKey = "no-key-provided"
}

# Ask for credentials
$psCredential = Get-Credential -UserName $userName -Message "Octopus credentials"

# Retrieve steps for the project and export them to the packages.config file
Octopus-GetProjectSteps $server $apiKey $project $psCredential | ExportSteps-PackagesConfig -outputFile $outputFile