param([String]$nugetRepo, [String]$apiKey)

Get-Module | % { if($_.Name -eq "NuGetRemi") { Remove-Module NuGetReMi}}
Import-Module .\NuGetReMi.psm1 -disablenamechecking
Get-Module | % { if($_.Name -eq "GitHelper") { Remove-Module GitHelper}}
Import-Module .\GitHelper.psm1 -disablenamechecking

$nuspecPath = $(Join-Path $(Get-Location) ..\ReMi.Api\.build)
$nuspecName = "ReMi.Api.nuspec"
$nugetConfig = $(Join-Path $(Get-Location) ..\.nuget\NuGet.config)
$outputFolder = $(Join-Path $nuspecPath "lib\\net45")
$matchPattern = ("ReMi.BusinessEntities.dll", "ReMi.BusinessLogic.dll", "ReMi.Common.Constants.dll", "ReMi.Common.Cqrs.FluentValidation.dll", 
    "ReMi.Common.WebApi.dll", "ReMi.Plugin.Composites.dll", "ReMi.DataAccess.dll", "ReMi.DataEntities.dll",
    "ReMi.DataEntityMaps.dll", "ReMi.Api.dll", "ReMi.CommandHandlers.dll", "ReMi.Commands.dll",
    "ReMi.CommandValidators.dll", "ReMi.EventHandlers.dll", "ReMi.Events.dll", "ReMi.Queries.dll",
    "Remi.QueryHandlers.dll", "ReMi.QueryValidators.dll")

$version = GetNextVersion $nuspecName $nuspecPath $nugetRepo

ChangeVersionInAssemblies $version $(Join-Path $nuspecPath ..\)

PublishToFileSystem $(Join-Path $nuspecPath ..\ServiceBoundary\ReMi.Api\ReMi.Api.csproj) $outputFolder

CleanupPackageContent $outputFolder $matchPattern

GenerateNuGetPackage $nuspecName $nuspecPath $version

PublishPackage $nugetRepo $nuspecName $nuspecPath $nugetConfig $apiKey

RemoveNuGetPackages $nuspecPath

$project = $nuspecName.Substring(0, $nuspecName.LastIndexOf(".nuspec"))
CommitPackage $project $version
