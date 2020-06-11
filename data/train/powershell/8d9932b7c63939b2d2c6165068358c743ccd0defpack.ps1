param(
	[bool]$clean = $true,
	[bool]$unittests = $true
)

# Initialization
$rootFolder = Split-Path -parent $script:MyInvocation.MyCommand.Path

. $rootFolder\nuget.include.ps1
. $rootFolder\build.include.ps1
. $rootFolder\tests.include.ps1

# Solution
$solutionFolder = Join-Path $rootFolder "PortableLeagueAPI"
$outputFolder = Join-Path $rootFolder "bin"

$projects = @(
	"LeagueAPI.PCL.Test\PortableLeagueAPI.Test.csproj",
	"PortableLeagueApi.Interfaces\PortableLeagueApi.Interfaces.csproj",
	"PortableLeagueApi.Core\PortableLeagueApi.Core.csproj",
	"PortableLeagueAPI.Champion\PortableLeagueApi.Champion.csproj",
	"PortableLeagueApi.Game\PortableLeagueApi.Game.csproj",
	"PortableLeagueApi.League\PortableLeagueApi.League.csproj",
	"PortableLeagueApi.Static\PortableLeagueApi.Static.csproj",
	"PortableLeagueApi.Stats\PortableLeagueApi.Stats.csproj",
	"PortableLeagueApi.Summoner\PortableLeagueApi.Summoner.csproj",
	"PortableLeagueApi.Team\PortableLeagueApi.Team.csproj",
	"LeagueAPI.PCL\PortableLeagueAPI.csproj"
)

# Do not build a .nupkg for these projects
$excludeNupkgProjects = @(
	$projects[0]
)

# Clean
if($clean) { Packages-Clean $rootFolder }

$newPackagesVersions = @{}
$config = "Release"

# Projects to build
$projects | ForEach-Object {
	$project = $_
		
	# Build project
	Build-Project -rootFolder $rootFolder `
		-outputFolder $outputFolder `
		-project $project `
		-config $config
	
	# Build .nupkg if project is not excluded and needed
	if(-not ($excludeNupkgProjects -contains $project)) {

		$projectFolder = Get-Project-Folder -rootFolder $rootFolder `
			-project $project

		$packageId = Get-Package-Id -rootFolder $rootFolder `
			-project $project

		$nuSpecFromNuget = Get-MostRecentNugetSpec -nugetPackageId $packageId
			
		$version = Get-Last-NuGet-Version -spec $nuSpecFromNuget
						
		$assemblyVersion = Get-Assembly-Version -projectFolder $projectFolder

		$isNewVersion = $false

		if($assemblyVersion -ne $version) {
			$version = $assemblyVersion
			$isNewVersion = $true
		}

		$newPackagesVersions.Add($packageId, $version)

		Update-Nuspec -rootFolder $rootFolder `
			-project $project `
			-newPackagesVersions $newPackagesVersions
			
		if($isNewVersion){

			Build-Nupkg -rootFolder $rootFolder `
				-outputFolder $outputFolder `
				-project $project `
				-version $version `
				-config $config
		}
	}
	else {

		if($unittests) {

			$buildFolder = Join-Path $outputFolder $config

			TestRunner-Nunit -rootFolder $rootFolder `
				-buildFolder $buildFolder
		}
	}
}