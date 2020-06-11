#First some common params, delivered by the nuget package installer
param($installPath, $toolsPath, $package, $project)


# Grab a reference to the buildproject using a function from NuGetPowerTools
$buildProject = Get-MSBuildProject

. (Join-Path $toolsPath common.ps1)

# Add a target to your build project
$target = $buildProject.Xml.AddTarget("Localization")

# Make this target run before build
# You don't need to call your target from the beforebuild target,
# just state it using the BeforeTargets attribute
$target.BeforeTargets = "BeforeBuild"
$target.Condition = "'`$`(Configuration`)' == 'Release'"

# Add your task to the newly created target
$task = $target.AddTask("Exec")
$task.SetParameter("Command", "`$`(ProjectDir`)`\Properties\Localization\localize.bat `"`$`(SolutionDir`)`" `"`$`(ProjectDir`)`"")

# Copy localization files only if they don't already exist

for ($i=0; $i -lt $filesArray.length; $i++)
{
	# if doesn't exist an exception will be thrown, then add it
	try {
		$localizationFolderProjectItem.ProjectItems.Item($filesArray[$i])
	} catch {
		$localizationFolderProjectItem.ProjectItems.AddFromFileCopy($toolsPath + "\Properties\Localization\" + $filesArray[$i])
	 }
}

# Save the buildproject
$buildProject.Save()

# Save the project from the params
$project.Save()