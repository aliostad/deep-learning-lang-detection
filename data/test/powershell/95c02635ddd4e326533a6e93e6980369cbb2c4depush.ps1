Param($version,$apikey)

if ($version -Eq $null) {
    $version = Read-Host "Enter Version Number"
}

if ($apikey -Eq $null) {
    $apikey = Read-Host "Enter API Key"
}

$project = "antix.imageUploadPreview.jquery"
$path = Split-Path -parent $PSCommandPath 
$srcPath = "$path\..\src\"

$packagePath = "$path\packages"
$package = "$packagePath\$project.$version.nupkg"

Write-Output "begin deploy version $version"

set-alias nuget $path\NuGet.exe

nuget pack "$path\$project.nuspec" -Properties version=$version -OutputDirectory "$packagePath"
nuget push "$package" -ApiKey $apikey