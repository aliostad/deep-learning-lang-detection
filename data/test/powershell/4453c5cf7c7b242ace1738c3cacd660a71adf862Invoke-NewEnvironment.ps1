[CmdletBinding()]
param
(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$environmentName,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$awsKey,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$awsSecret,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$octopusApiKey,
    [string]$awsRegion="ap-southeast-2"
)

$currentDirectoryPath = Split-Path $script:MyInvocation.MyCommand.Path

. "$currentDirectoryPath\_Find-RootDirectory.ps1"
. "$currentDirectoryPath\Functions-Environment.ps1"

$rootDirectory = Find-RootDirectory $currentDirectoryPath

$result = New-Environment $environmentName $awsKey $awsSecret $awsRegion -Wait -octopusApiKey $octopusApiKey

return (ConvertTo-Json $result)