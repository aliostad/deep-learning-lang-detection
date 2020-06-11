if (-not (Get-Module "BuildBootstrap"))
{
    throw "BuildBootstrap module must be loaded"
}

$nugetFolder = Get-LatestPackageFolder("Nuget.CommandLine")
$nuget_exe = "$nugetFolder\tools\NuGet.exe"

$deployFeedFolder = ""
$deployFeed = ""
$deployApiKey = ""
$nugetFeedFolder = "c:\temp\nuget"
$nugetFeed = ""
$nugetApiKey = ""

$deployPackageMatch = ".Deploy"

function Build-Packages (
        [string]$location,
        [string]$output,
        [string]$defaultNugetVersion)
{
    Write-Host "Build Nuget packages"

    Push-Location

    Set-Location $location

    mkdir -Force $output

    if (!$defaultNugetVersion) {
        Write-Host "No default nuget version given. Using timestamp instead"
        $defaultNugetVersion = Get-NuGetDateTimeVersion
    }

    # Find all .nuspec files
    Get-ChildItem -Include *.nuspec -Recurse | % {

        # Get the name of the package
        $nameOfPackage = $_.BaseName
        $pathOfPackage = Split-Path -parent $_.FullName

        # Look for a .nuversion file
        if (Test-Path "$pathOfPackage\$nameOfPackage.nuversion") {
            # If we find a .nuversion file, use the version number from it
            $nugetVersion = Get-Content "$pathOfPackage\$nameOfPackage.nuversion"
        } else {
            # Otherwise, use the current date/time
            $nugetVersion = $defaultNugetVersion
            # Also, let's write this to a new .nuversion-file
            $nugetVersion | Set-Content "$pathOfPackage\$nameOfPackage.nuversion"
        }

        # Build the package
        & $nuget_exe pack $_ -outputDirectory $output -version $nugetVersion
    }

    Pop-Location

}
function Publish-Packages ($location) 
{
    Write-Host "Publishing Nuget packages"

    Push-Location

    Set-Location $location

    # Find all created packages
    Get-ChildItem | % {

        # Is it a deploy package or "normal" package?
        if ($_.Name -match $deployPackageMatch) {
            $feedFolder = $deployFeedFolder
            $feed = $deployFeed
			$apiKey = $deployApiKey
        } else {
            $feedFolder = $nugetFeedFolder
            $feed = $nugetFeed
			$apiKey = $nugetApiKey
        }

        # Create the full path of the source file
        $sourceFile = $_.Name

        if ($feedFolder) {
            # Create the name of the destination file
            $destinationFile = Join-Path $feedFolder $_.Name

            # Check if it's already published
            if (Test-Path $destinationFile) {
              Write-Host $_.Name "already exists in feed. Please update the package version!"
            } else {
              cp $sourceFile -destination $feedFolder
            }
        }

        if ($feed) {
            # If we have a feed specified, push to it
			if ($apiKey) {
				& $nuget_exe push $sourceFile -ApiKey $apiKey -Source $feed
			} else {
				& $nuget_exe push $sourceFile -Source $feed
			}
        }
    }

	Pop-Location
}

function Get-NuGetDateTimeVersion
{
    Get-Date -format "yyyy.MM.dd.HHmm"
}
