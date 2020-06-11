Param($version,$apiKey)

Write-Host "NuGet build and push Antix.Building"

if ($version -Eq $null) {
    $version = Read-Host "Enter Version Number"
}

$nugetPath = Split-Path -parent $PSCommandPath
$sourcePath = "$nugetPath\..\antix-building"
$destinationPath = "$nugetPath\Packages\$version"

# Create Package Structure
New-Item -Path "$destinationPath" -Type directory -ErrorAction Stop

# Package
set-alias nuget $sourcePath\.nuget\NuGet.exe

nuget pack "$sourcePath\Antix.Building\Antix.Building.csproj" -Properties version=$version -OutputDirectory "$destinationPath"

if ($apiKey -ne $null) {
    
    $key = read-Host "Confirm push to nuget (Y)"
    if($key -eq "y") {

        # Push
        nuget SetApiKey $apiKey

        nuget push $destinationPath\Antix.Building.$version.nupkg
    }
}

read-host "Press enter to close..."