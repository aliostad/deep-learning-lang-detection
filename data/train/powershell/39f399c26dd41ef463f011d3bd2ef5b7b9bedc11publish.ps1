Param (
    $parameters = @{},
    $srcFolder,
    $projectName,
    $projectVersion
)

# get script variables
$nugetApiKey = $parameters["NuGetApiKey-secure"]
$semver = $projectVersion + $parameters["BuildLabel"]

# update package version in nuspec file
Write-Output "Updating version in nuspec file"
$nuspecPath = "$srcFolder\TplDataflow.Extensions\TplDataflow.Extensions.nuspec"
[xml]$xml = Get-Content $nuspecPath
$xml.package.metadata.version = $semver
$xml.Save($nuspecPath)

# build NuGet package
Write-Output "Building NuGet package"
.\.nuget\NuGet.exe pack $nuspecPath

# publish NuGet package
Write-Output "Publishing NuGet package"
.\.nuget\NuGet.exe push $srcFolder\Adform.TplDataflow.Extensions.$semver.nupkg $nugetApiKey