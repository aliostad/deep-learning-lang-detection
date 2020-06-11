$proj = "SOVND.Client"
$nugetServer = $env:NugetServer
$apiKey = $env:NugetKey

$root = $env:APPVEYOR_BUILD_FOLDER
$versionStr = "$($env:APPVEYOR_BUILD_VERSION)"

nuget pack $root\nuget\$proj.nuspec -OutputDirectory $root\nuget\ -Version $versionStr

If($lastexitcode -eq 0)
{
	Write-Host "Nuget package built successfully"
	nuget push $root\nuget\*.nupkg -Source $nugetServer $apiKey
	
	#Squirrel --releasify $root/nuget/SOVND.Client-$env:APPVEYOR_BUILD_VERSION.nupkg
} else {
	Write-Host "Nuget packaging error $($lastexitcode)"
}