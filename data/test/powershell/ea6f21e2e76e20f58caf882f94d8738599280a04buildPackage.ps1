# params

param(
	[string]$push = "false",
	[string]$v = "",
	[string]$source = ""
)

# functions

function ReadLinesFromFile([string] $fileName)
{
 [string]::join([environment]::newline, (get-content -path $fileName))
}

function BuildSolution
{
  [CmdletBinding()]
  param()
  C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe ..\SevenDigital.Api.Schema.sln /t:build /p:Configuration=Debug
}

function CleanupBuildArtifacts
{
  [CmdletBinding()]
  param()
  
  del SevenDigital.Api.Schema.nuspec
  del *.nupkg
}

# main script

BuildSolution

$fullVersion = $v
if ($fullVersion -eq "")
{
  write-output "You must specify a version number with '-v' "
  exit
}
else
{
  write-output "Next package version from params: $fullVersion"
}


# make the nuspec file with the target version number
$nuspecTemplate = ReadLinesFromFile "SevenDigital.Api.Schema.nuspec.template"
$nuspecWithVersion = $nuspecTemplate.Replace("#version#", $fullVersion)
$nuspecWithVersion > SevenDigital.Api.Schema.nuspec

nuget pack SevenDigital.Api.Schema.nuspec 

$pushCommand = "NuGet Push SevenDigital.Api.Schema.#version#.nupkg -NonInteractive".Replace("#version#", $fullVersion)

if ($source -ne "")
{
  $pushCommand = $pushCommand + " -source $source"
}

if ($push -eq "true")
{
  # push to nuget:
  Invoke-Expression $pushCommand
  write-output "Pushed package version $fullVersion"
}
else
{
 # dry run
  write-output "Dry run: specify '-push true' to push to nuget"
  write-output "Next package version: $fullVersion"
  write-output "Command is: $pushCommand"
}
CleanupBuildArtifacts

write-output "Done"