param
(
    [string] $NuGetExecutable = "..\.nuget\nuget",
    [string] $NuGetFeed = "https://www.nuget.org/api/v2/package",
    [string] $NuGetApiKey = "valid-api-key-here" 
)

# Define some parameters
$TargetPath = Split-Path $MyInvocation.MyCommand.Path
$BuildConfiguration = "Release"

# Exit if target path is not existing
if(-not (Test-Path $TargetPath)) {
	Write-Error "TargetPath $TargetPath is not valid."
	Exit 1
}

# Find all .nupkg files (not in packages folder) ...
$packages = @(Get-ChildItem $TargetPath -Filter "*.nupkg" -Recurse | `
  ? { $PSItem.FullName -inotmatch "\\packages\\" } | `
  % { $PSItem.FullName } `
)

[string]$message = "Found " + ($packages.Count).ToString() + " .nupkg file(s)..."
Write-Verbose -Message $message -Verbose

# ... and publish them to the NuGet feed
foreach ($package in $packages) {
	[string]$processingMessage = "Pushing " + $package + " to NuGet feed " + $NuGetFeed
	Write-Verbose -Message $processingMessage -Verbose

    # Write-Host $NuGetExecutable push $package -source $NuGetFeed -apikey API_KEY
	$NuGetPushParameters = "push", $package, "-source", $NuGetFeed, "-apikey", $NuGetApiKey

	[string]$response = & $NuGetExecutable $NuGetPushParameters 2>&1

	#Write-Host "Response: " $response
	if(-not ($response -like "*Created*" -and $response -like "*Your package was pushed*")) {
		
		if (-not ($response -like "*Conflict*" -and $response -like "*already exists and cannot be modified*")) {
			Write-Error $response
			Exit 1
		}

		Write-Host "NuGet package has not been published, because the package already exists."
	}
}

Exit 0