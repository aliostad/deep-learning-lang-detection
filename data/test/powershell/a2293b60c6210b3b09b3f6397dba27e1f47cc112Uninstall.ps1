﻿param($installPath, $toolsPath, $package, $project)

Write-Host 'Removing BuildTools...'
$solutionPath = (Get-Item $installPath).Parent.Parent.FullName

# Remove the reference to the BuildTools.targets file...
Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
$msbuildProject =  [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1
$import = $msbuildProject.Xml.Imports | Where-Object { $_.Project.Endswith('BuildTools.targets') }
if ($import) {
	Write-Host 'Dereferencing BuildTools MSBuild targets file...'
	$msbuildProject.Xml.RemoveChild($import)
}

# Save the project changes...
$project.Save()
$msbuildProject.Save()
