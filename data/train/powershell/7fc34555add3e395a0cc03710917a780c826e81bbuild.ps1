<#
.SYNOPSIS
  Pack, test and publish RedGate.Teamcity

.DESCRIPTION
  1. nuget pack RedGate.Teamcity.nuspec
  2. If Nuget Feed Url and Api key are passed in, publish the RedGate.Teamcity package
#>
[CmdletBinding()]
param(
    # The version of the nuget package.
    [Parameter(Mandatory = $False)]
    [string] $Version = '0.0.1-dev',

    # True when building from master. If False, '-prerelease' is appended to the package version.
    [Parameter(Mandatory = $False)]
    [bool] $IsDefaultBranch = $False,

    # A url to a NuGet feed the package will be published to.
    [Parameter(Mandatory = $False)]
    [string] $NugetFeedToPublishTo,

    # The Api Key that allows pushing to the feed passed in as -NugetFeedToPublishTo.
    [Parameter(Mandatory = $False)]
    [string] $NugetFeedApiKey
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue' #important for Invoke-WebRequest to perform well when executed from Teamcity.

Push-Location $PSScriptRoot
try {
    # Import the TeamCity module.
    Import-Module '.\teamcity.psm1' -Force

    if(!$IsDefaultBranch) {
        # If we are not building from master, append '-prerelease' to the package version
        $Version = "$Version-prerelease"
        # let TC know
        TeamCity-SetBuildNumber($Version)
    }

    # Download NuGet if necessary.
    if(!(Test-Path .\nuget.exe)) {
        Invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/v3.3.0/nuget.exe" -OutFile .\nuget.exe -verbose
    }

    Write-Verbose 'Packaging the RedGate.Teamcity module' -verbose
    .\nuget.exe pack .\RedGate.Teamcity.nuspec -NoPackageAnalysis -Version $Version
    if($LASTEXITCODE -ne 0) {
        throw "Could not nuget pack RedGate.Teamcity. nuget returned exit code $LASTEXITCODE"
    }

    # Publish the NuGet package.
    if($IsDefaultBranch -and $NugetFeedToPublishTo -and $NugetFeedApiKey) {
        Write-Verbose 'Publishing the RedGate.Teamcity module nuget package' -verbose
        # Let's only push the packages from master when nuget feed info is passed in...
        & .\nuget.exe push "RedGate.Teamcity.$Version.nupkg" -Source $NugetFeedToPublishTo -ApiKey $NugetFeedApiKey
        if($LASTEXITCODE -ne 0) {
            throw "Could not nuget pack RedGate.Teamcity. nuget returned exit code $LASTEXITCODE"
        }
    } else {
        Write-Verbose 'Publish skipped' -verbose
    }

} finally {
    Pop-Location
}
