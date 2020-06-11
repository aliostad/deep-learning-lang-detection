param (
    [Version]$Version,
    [Parameter(Mandatory = $true)]
    [string]$ApiKey,
    [switch]$Force
)

$packageName = 'HyperVLab'
$repositoryName = 'PSGallery'

if ($Version) {
    Write-Host -Object "Finding installed version of the module on '$repositoryName'..."
    $module = Get-Module -Name $packageName -ListAvailable -All -ErrorAction Stop | Where-Object { $_.Version -eq '0.0.1.40' } | Select-Object -First 1
}
else {
    Write-Host -Object "Finding installed version of the module on '$repositoryName'..."
    $module = Get-Module -Name $packageName -ListAvailable -ErrorAction Stop
}
if (-not $module) {
    throw 'Module not found.'
}

$Version = "$($module.Version)"
Write-Host -Object "Selected version: '$Version'"

if (-not $Force.IsPresent) {
    $publish = Read-Host -Prompt 'Do you wish to publish? [y]es or [n]o'
}
else {
    $publish = 'Y'
}
if ($publish.ToUpperInvariant() -in 'Y','YES') {
    # publish the module
    Write-Host -Object "Publishing version '$Version'"
    $module | Publish-Module -Repository $repositoryName -NuGetApiKey $ApiKey
    Write-Host -Object "Version '$Version' published"
}
