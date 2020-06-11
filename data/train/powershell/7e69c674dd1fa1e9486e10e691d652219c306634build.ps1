Param($version,$apiKey)

Write-Host "NuGet build and push Antix.Testing"

if ($version -Eq $null) {
    $version = Read-Host "Enter Version Number"
}

$nugetPath = Split-Path -parent $PSCommandPath
$sourcePath = "$nugetPath\..\antix-testing"
$destinationPath = "$nugetPath\Packages\$version"

# Create Package Structure
New-Item -Path "$destinationPath" -Type directory -ErrorAction Stop

# Package
set-alias nuget $sourcePath\.nuget\NuGet.exe

nuget pack "$sourcePath\Antix.Testing\Antix.Testing.csproj" -Properties version=$version -OutputDirectory "$destinationPath"

if ($apiKey -ne $null) {
    
    $key = read-Host "Confirm push to nuget (Y)"
    if($key -eq "y") {

        # Push
        nuget SetApiKey $apiKey

        nuget push $destinationPath\Antix.Testing.$version.nupkg
    }
}

read-host "Press enter to close..."