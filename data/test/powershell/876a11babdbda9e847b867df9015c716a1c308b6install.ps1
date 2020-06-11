param($installPath, $toolsPath, $package, $project)

# Set Copy Local to false for all mg-desktop references
foreach ($reference in $project.Object.References)
{
    if ($reference.Name -eq "OSGeo.MapGuide.MapGuideCommon" -or
        $reference.Name -eq "OSGeo.MapGuide.Web")
    {
        $reference.CopyLocal = $true
    }
}
Write-Host "Set <Copy Local> = true for all Web API references"

. (Join-Path $toolsPath "GetMgWebApiPostBuildCmd.ps1")

# Get the current Post Build Event cmd
$currentPostBuildCmd = $project.Properties.Item("PostBuildEvent").Value

# Append our post build command if it's not already there
if (!$currentPostBuildCmd.Contains($MgWebApiPostBuildCmd)) {
    $project.Properties.Item("PostBuildEvent").Value += $MgWebApiPostBuildCmd
    Write-Host "Updated Post-Build event for project"
}