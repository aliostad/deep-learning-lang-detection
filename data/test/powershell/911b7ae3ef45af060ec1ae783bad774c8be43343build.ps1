Param($apiKey)

$nugetPath = Split-Path -parent $PSCommandPath
$sourcePath = "$nugetPath\..\.."
$destinationPath = "$nugetPath\Packages"
$project = "$sourcePath\Antix.Logging\Antix.Logging.csproj"

# Create Package Structure
New-Item -Path "$destinationPath" -Type directory -erroraction ignore

# build
c:\windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe $project /t:Build


# Package
set-alias nuget $sourcePath\.nuget\NuGet.exe

$output = nuget pack $project -OutputDirectory "$destinationPath"

("$output" -match "\\([\w\.]*\.nupkg)'\.")
$package = $matches[1]

write-host "created "$destinationPath\$package

if ($apiKey -ne $null) {
    
    # Push 
    nuget SetApiKey $apiKey

    nuget push $destinationPath\$package
}

read-host "Press enter to close..."