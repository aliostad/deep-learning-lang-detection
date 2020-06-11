Param($version,$apiKey)

if ($version -Eq $null) {
    $version = Read-Host "Enter Version Number"
}

$nugetPath = Split-Path -parent $PSCommandPath
$sourcePath = "$nugetPath\..\src"
$destinationPath = "$nugetPath\Packages\$version"

# Create Package Structure
New-Item -Path "$destinationPath" -Type directory -ErrorAction Stop

# Package
set-alias nuget $sourcePath\.nuget\NuGet.exe

nuget pack "$sourcePath\Antix.Blackhole\Antix.Blackhole.nuspec" -Properties version=$version -OutputDirectory "$destinationPath"

if ($apiKey -ne $null) {
    
    # Push 
    nuget SetApiKey $apiKey

    nuget push $destinationPath\Antix.Blackhole.$version.nupkg
}

read-host "Press enter to close..."