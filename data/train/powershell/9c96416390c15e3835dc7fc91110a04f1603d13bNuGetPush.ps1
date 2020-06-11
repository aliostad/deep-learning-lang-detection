Param(
  [string]$nugetApiKey,
  [string]$nuGetGalleryServer="https://www.nuget.org",
  [string]$Stable="yes",  
  [string]$Development="no"  
)

Push-Location $PSScriptRoot

. ".\ManageBuildNumbers.ps1"

# Move to the parent (SolutionDir).
Push-Location ..

$nugetExecutable = Get-ChildItem "./.nuget/NuGet.exe" -Recurse | Select -First 1 
Set-Alias Execute-NuGet $nugetExecutable

Echo "Updating NuGet..."
Execute-NuGet Update -self

$buildNumber = Get-BuildVersion
Echo "Building current version $buildNumber ..."

# Setting the Build Server API Key
Execute-NuGet SetApiKey $nugetApiKey -Source $nuGetGalleryServer

# Push the package.
$nupkgFiles = ".\NuGetBuild\ArraySlice.Fody.$buildNumber.nupkg"
Execute-NuGet push $nupkgFiles


Pop-Location
Pop-Location