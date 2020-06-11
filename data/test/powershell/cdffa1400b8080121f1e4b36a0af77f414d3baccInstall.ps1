#First some common params, delivered by the nuget package installer
param($installPath, $toolsPath, $package, $project)
Set-PsDebug -trace 2
"Echo installing..."
# Grab a reference to the buildproject using a function from NuGetPowerTools
$buildProject = Get-MSBuildProject
# Add a target to your build project
$target = $buildProject.Xml.AddTarget("Localization")
# Make this target run before build
# You don't need to call your target from the beforebuild target,
# just state it using the BeforeTargets attribute
$target.BeforeTargets = "BeforeBuild"
# Add your task to the newly created target
$task = $target.AddTask("Exec")
$task.SetParameter("Command", "..\packages\DotNetWise.Utilities.0.1.62.851\tools\localize.bat `"`$`(SolutionDir`)`" `"`$`(ProjectDir`)`"")

# Save the buildproject
$buildProject.Save()
# Save the project from the params
$project.Save()

