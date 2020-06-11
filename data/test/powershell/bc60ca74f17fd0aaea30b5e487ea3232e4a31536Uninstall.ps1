param($installPath, $toolsPath, $package, $project)

Write-Host 'Removing BreakCop...'
$solutionPath = (Get-Item $installPath).Parent.Parent.FullName

# Remove the reference to the BreakCop.targets file...
Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
$msbuildProject =  [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1
$import = $msbuildProject.Xml.Imports | Where-Object { $_.Project.Endswith('BreakCop.targets') }
if ($import) {
	Write-Host 'Dereferencing BreakCop MSBuild targets file...'
	$msbuildProject.Xml.RemoveChild($import)
}

# Save the project changes...
$project.Save()
$msbuildProject.Save()
