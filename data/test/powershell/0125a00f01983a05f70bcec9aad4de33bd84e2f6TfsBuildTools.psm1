
function loadDependencies 
{
    #load types
    add-type -Path "$($env:VS120COMNTOOLS)..\IDE\ReferenceAssemblies\v2.0\Microsoft.TeamFoundation.Build.Workflow.dll"
    
    #load assemblies
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client") 
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client") 
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Workflow")
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Common") 
}

Push-Location $PSScriptRoot
. .\TfsBuildTools.BuildServer.ps1
. .\TfsBuildTools.BuildDefinition.ps1
. .\TfsBuildTools.WorkspaceMappings.ps1
. .\TfsBuildTools.ProjectsToBuild.ps1
. .\TfsBuildTools.AdvancedBuildSettings.ps1
. .\TfsBuildTools.AdvancedTestSettings.ps1
. .\TfsBuildTools.AutomatedTestSettings.ps1
Pop-Location

loadDependencies

#export only the function names that contain a hyphen (and thus are cmdlets)
Export-ModuleMember -function *-*