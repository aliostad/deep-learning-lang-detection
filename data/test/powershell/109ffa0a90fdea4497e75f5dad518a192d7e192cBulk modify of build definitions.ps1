. d:\silo18\Main\ALM\Common\TFS-Helper.ps1
$tfsCollectionUrl = "http://bgotfs01:8080/tfs"

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")  
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")  
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Common")  
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.VersionControl.Client")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Workflow")  

$tfsService = new-object Microsoft.TeamFoundation.Client.TfsTeamProjectCollection(New-Object Uri($tfsCollectionUrl))
$buildService = $tfsService.GetService([Microsoft.TeamFoundation.Build.Client.IBuildServer])

$projectBuildDefinitions = $buildService.QueryBuildDefinitions("RGS")

<#
foreach ($builDefinition in $projectBuildDefinitions)
{
    Write-Host $builDefinition.DefaultDropLocation -ForegroundColor Yellow
    $builDefinition.DefaultDropLocation = "\\bgodata03\Artefacts\RGS"
    Write-Host $builDefinition.DefaultDropLocation -ForegroundColor Green
    $builDefinition.Save();
}
#>

$projectBuildDefinitions = $buildService.QueryBuildDefinitions("Silo18")

foreach ($builDefinition in $projectBuildDefinitions)
{
    Write-Host $builDefinition.Name -ForegroundColor White
    Write-Host $builDefinition.DefaultDropLocation -ForegroundColor Yellow
    $builDefinition.DefaultDropLocation = "\\bgodata03\Artefacts\BGO"
    Write-Host $builDefinition.DefaultDropLocation -ForegroundColor Green
    $builDefinition.Save();
}

