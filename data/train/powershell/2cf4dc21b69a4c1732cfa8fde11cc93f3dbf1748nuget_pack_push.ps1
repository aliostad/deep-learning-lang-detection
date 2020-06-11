# Enable -Verbose option
[CmdletBinding()]

param([String] $nuget, [String] $apiKey, [String] $workingDir)

# Check if path to nuget.exe is specified
if (-not $nuget)
{
	Write-Error ("The path to NuGet.exe is not specified.")

	exit 1
}

# Check if working directory is specified
if (-not $workingDir)
{
	Write-Error ("The output directory is not specified.")

	exit 1
}

# Compose output directory path
$outDir = "$workingDir\.pkg"

# Create output directory
New-Item $outDir -type directory

# Set api key
Invoke-Expression "$nuget setApiKey $apiKey"

# Enumerate nuspec files in build output directory
$nuspecFiles = Get-ChildItem -Path $workingDir -Recurse -File -Include '*.nuspec'

foreach ($nuspecFile in $nuspecFiles)
{
	# Pack NuGet package
	Invoke-Expression "$nuget pack $nuspecFile -Verbosity detailed -Symbols -OutputDirectory $outDir"
}

# Enumerate packages files
$packageFiles = Get-ChildItem -Path $outDir -Recurse -File -Include '*.nupkg' -Exclude '*.symbols.nupkg'

foreach ($file in $packageFiles)
{
	# Push packages
	Invoke-Expression "$nuget push $file"
}