Param (
    $variables = @{},   
    $artifacts = @{},
    $scriptPath,
    $buildFolder,
    $srcFolder,
    $outFolder,
    $tempFolder,
    $projectName,
    $projectVersion,
    $projectBuildNumber
)

# list all artifacts
foreach($artifact in $artifacts.values)
{
    Write-Output "Artifact: $($artifact.name)"
    Write-Output "Type: $($artifact.type)"
    Write-Output "Path: $($artifact.path)"
    Write-Output "Url: $($artifact.url)"
}
$artifact = $artifacts
cd $srcFolder
Write-Output "Source Folder: $srcFolder"
Write-Output ".\.nuget\nuget.exe push $($artifacts.values[0].path) $($variables["secureNuGetApiKey"]) -Source $($variables["nugetApiUri"])"
.\.nuget\nuget.exe push $($artifacts.values[0].path) $variables["secureNuGetApiKey"] -Source $variables["nugetApiUri"]

