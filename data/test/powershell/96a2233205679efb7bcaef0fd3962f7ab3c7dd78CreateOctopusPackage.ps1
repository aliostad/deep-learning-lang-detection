[CmdletBinding()]
param(
    [Parameter(Mandatory)][string] $PackageId,
    [Parameter(Mandatory)][string] $PackageVersion,
    [Parameter(Mandatory)][string] $PackageFromDirectory,
    [Parameter(Mandatory)][string] $DropDirectory,
    [Parameter(Mandatory)][string] $OctopusServer,
    [Parameter(Mandatory)][string] $OctopusApiKey
)

choco install OctopusTools -y
choco install nuget.commandline -y

mkdir "$DropDirectory" -f

octo pack --id $PackageId --version $PackageVersion --basePath "$PackageFromDirectory" --outFolder "$DropDirectory"

$packageName = "$DropDirectory\$PackageId" + ".$PackageVersion" + ".nupkg"

nuget push $packageName -Source "$OctopusServer" -ApiKey "$OctopusApiKey"