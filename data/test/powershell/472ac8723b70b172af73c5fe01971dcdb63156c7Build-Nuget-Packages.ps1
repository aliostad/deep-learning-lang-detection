$nuget = ".\nuget.exe"
$nugetparams = "-Build", "-IncludeReferencedProjects"
$nugetapikey = "55bb9591-f442-42fc-ac6c-d44f785a32bf"
$nugetServer = "https://www.nuget.org/api/v2/package"

$projects = @("..\GridMaps\GridMaps.csproj")

Write-Host "Starting nuget packaging"

foreach($proj in $projects) {
    Write-Host "Packaging $($proj)."
    & $nuget pack $proj $nugetparams
    if($LastExitCode -ne 0) {
        Write-Error "Failed to build $($proj)."
        continue
    }
}

Write-Host "Nuget packaging finished"

#Write-Host "Try to upload packages"

#& $nuget setApiKey $nugetapikey

#$packages = get-childitem | where {$_.extension -eq ".nupkg"}

#foreach($package in $packages) {
#    & $nuget push $package -Source $nugetServer
#}

#Write-Host "Upload complete!"