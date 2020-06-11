function Publish-NuGetPackage{
<#
 
.SYNOPSIS
    Given the a path to a NuGet (.nupkg) package will publish (nuget push) the package to nuget.org.
.DESCRIPTION
    Given the a path to a NuGet (.nupkg) package will publish (nuget push) the package to nuget.org and optionally publish the symbol source package (.symbols.nupkg) matching the naming convention, i.e. <packageName>.symbols.nupkg.
.NOTES
	Requirements: Copy this module to any location found in $env:PSModulePath
.PARAMETER nugetPackagePath
	Required. The path to the NuGet (.nupkg) package to publish, i.e. nuget push, relative to the calling scripts location.
.PARAMETER nugetApiKey
	Required. A valid Nuget API key to publish to nuget.org
.PARAMETER nuGetPath
	Optional. The full path to the nuget.exe console application.  Defaults to 'packages\NuGet.CommandLine.2.7.3\tools\nuget.exe', i.e. the bundled version of NuGet.	
	
.EXAMPLE 
	Import-Module Publish-NuGetPackage
	Import the module
.EXAMPLE	
	Get-Command -Module Publish-NuGetPackage
	List available functions
.EXAMPLE
	Publish-NuGetPackage -nugetPackagePath "BuildOutput\Femah.Core.0.1.0-beta.nupkg" -nugetApiKey "jhgjahgd656253"
	Execute the module
#>
	[cmdletbinding()]
		Param(
			[Parameter(
				Position = 0,
				Mandatory = $True )]
				[string]$nugetPackagePath,		
			[Parameter(
				Position = 1,
				Mandatory = $True )]
				[string]$nugetApiKey,
			[Parameter(
				Position = 2,
				Mandatory = $False )]
				[string]$nuGetPath				
			)
	Begin {
			$DebugPreference = "Continue"
		}	
	Process {
				Try 
				{
					#Set the basePath to the calling scripts path (using Resolve-Path .)
					$basePath = Resolve-Path .
					if ($nuGetPath -eq "")
					{
						#Set our default value for nuget.exe
						$nuGetPath = "$basePath\packages\NuGet.CommandLine.2.7.3\tools\nuget.exe"
					}
					
					$nugetPackagePath = "$basePath\$nugetPackagePath"
					
					if ((Test-Path -Path $nugetPackagePath) -eq $False) { 
						throw "Unable to find Nuget package: ""$packageToPublish"" to publish to nuget.org."
						return
					}

					& $nuGetPath push $nugetPackagePath -ApiKey $nugetApiKey -Verbosity detailed -NonInteractive

				}
				catch [Exception] {
					throw "Error executing NuGet Push for supplied Nuget pakcgaes file: $nugetPackagePath using NuGet from: $nuGetPath `r`n $_.Exception.ToString()"
				}
		}
}