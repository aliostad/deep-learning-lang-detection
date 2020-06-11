[CmdletBinding()]
param
(
    [switch]$deploy,
    [string]$environment,
    [string]$octopusServerUrl,
    [string]$octopusApiKey,
    [string[]]$projects
)

$error.Clear()
$ErrorActionPreference = "Stop"

$here = Split-Path $script:MyInvocation.MyCommand.Path

. "$here\_Find-RootDirectory.ps1"

$rootDirectory = Find-RootDirectory $here
$rootDirectoryPath = $rootDirectory.FullName

. "$rootDirectoryPath\scripts\Functions-Bootstrap.ps1"
Ensure-CommonScriptsAvailable

. "$rootDirectoryPath\scripts\common\Functions-Build.ps1"
. "$rootDirectoryPath\scripts\common\Functions-Enumerables.ps1"

$arguments = @{}
$arguments.Add("Deploy", $deploy)
$arguments.Add("Environment", $environment)
$arguments.Add("OctopusServerUrl", $octopusServerUrl)
$arguments.Add("OctopusServerApiKey", $octopusApiKey)
$arguments.Add("IsMsbuild", $false)
$arguments.Add("Subdirectory", "jmeter")

if (-not (($projects -ne $null) -and ($projects | Any)))
{
    $arguments.Add("OctopusProjectPrefix", "JMETER_")
}
else
{
    $arguments.Add("Projects", $projects)
}

Build-DeployableComponent @arguments