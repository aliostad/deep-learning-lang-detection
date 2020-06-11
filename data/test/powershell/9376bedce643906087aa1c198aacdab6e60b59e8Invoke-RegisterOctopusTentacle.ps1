[CmdletBinding()]
param
(
    [Parameter(Mandatory=$true)]
    [string[]]$octopusEnvironments,
    [Parameter(Mandatory=$true)]
    [string[]]$octopusRoles,
    [Parameter(Mandatory=$true)]
    [string]$octopusServerUrl,
    [Parameter(Mandatory=$true)]
    [string]$octopusApiKey
)

$ErrorActionPreference = "Stop"

$here = Split-Path $script:MyInvocation.MyCommand.Path
write-host "Script Root Directory is [$here]."

. "$here\_Find-RootDirectory.ps1"

$rootDirectory = Find-RootDirectory $here
$rootDirectoryPath = $rootDirectory.FullName

. "$rootDirectoryPath\scripts\common\Functions-OctopusDeploy-Installation.ps1"

Register-Tentacle -octopusApiKey $octopusApiKey -octopusServerUrl $octopusServerUrl -Roles $octopusRoles -Environments $octopusEnvironments