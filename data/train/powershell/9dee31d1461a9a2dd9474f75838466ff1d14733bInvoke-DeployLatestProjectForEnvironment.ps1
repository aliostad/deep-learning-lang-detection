[CmdletBinding()]
param
(
    [Parameter(Mandatory=$true)]
    [string]$octopusEnvironment,
    [Parameter(Mandatory=$true)]
    [string]$octopusServerUrl,
    [Parameter(Mandatory=$true)]
    [string]$octopusServerApiKey,
    [Parameter(Mandatory=$true)]
    [string]$projectName,
    [hashtable]$variables
)

$ErrorActionPreference = "Stop"

$here = Split-Path $script:MyInvocation.MyCommand.Path
write-host "Script Root Directory is [$here]."

. "$here\_Find-RootDirectory.ps1"

$rootDirectory = Find-RootDirectory $here
$rootDirectoryPath = $rootDirectory.FullName

. "$rootDirectoryPath\scripts\common\Functions-OctopusDeploy.ps1"

New-OctopusDeployment -ProjectName $projectName -Environment "$octopusEnvironment" -OctopusServerUrl $octopusServerUrl -OctopusApiKey $octopusServerApiKey -OnlyCurrentMachine -Wait -Variables $variables