[CmdletBinding()]
param
(
    [switch]$deploy,
    [string]$environment,
    [string]$octopusServerUrl="http://octopus.aws.console.othsolutions.com.au:8088/",
    [string]$octopusApiKey,
    [string[]]$projects
)

$error.Clear()
$ErrorActionPreference = "Stop"

$here = Split-Path $script:MyInvocation.MyCommand.Path

. "$here\_Find-RootDirectory.ps1"

$rootDirectory = Find-RootDirectory $here
$rootDirectoryPath = $rootDirectory.FullName

. "$rootDirectoryPath\scripts\common\Functions-Build.ps1"
. "$rootDirectoryPath\scripts\common\Functions-Enumerables.ps1"

$arguments = @{}
$arguments.Add("Deploy", $deploy)
$arguments.Add("Environment", $environment)
$arguments.Add("OctopusServerUrl", $octopusServerUrl)
$arguments.Add("OctopusServerApiKey", $octopusApiKey)
$arguments.Add("IsMsbuild", $false)

if (-not (($projects -ne $null) -and ($projects | Any)))
{
    $arguments.Add("OctopusProjectPrefix", "SQUID_")
}
else
{
    $arguments.Add("Projects", $projects)
}

Build-DeployableComponent @arguments