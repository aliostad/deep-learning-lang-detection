Param (
    $parameters = @{},
    $srcFolder,
    $projectName,
    $projectVersion
)

# get script variables
$nugetApiKey = $parameters["NuGetApiKey-secure"]

# update package version in nuspec file
Write-Output "Updating version in nuspec file"
$nuspecPath = "$srcFolder\AppVeyor.Deployment.nuspec"
[xml]$xml = Get-Content $nuspecPath
$xml.package.metadata.version = $projectVersion
$xml.Save($nuspecPath)

# build NuGet package
Write-Output "Building NuGet package"
.\NuGet.exe pack AppVeyor.Deployment.nuspec

# publish NuGet package
Write-Output "Publishing NuGet package"
.\NuGet.exe push $srcFolder\AppVeyor.Deployment.$projectVersion.nupkg $nugetApiKey