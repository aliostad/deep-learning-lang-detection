param($installPath, $toolsPath, $package, $project)

$targetFileName = 'CreateSnkFile.targets'
$targetFullFileName = [IO.Path]::Combine($toolsPath, $targetFileName)
$targetUri = New-Object Uri($targetFullFileName, [UriKind]::Absolute)

$msBuildV4Name = 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a';
$msBuildV4 = [System.Reflection.Assembly]::LoadWithPartialName($msBuildV4Name)

if(!$msBuildV4) {
    throw New-Object System.IO.FileNotFoundException("Could not load $msBuildV4Name.");
}

$msBuildV4.GetType('Microsoft.Build.Evaluation.ProjectCollection')::GlobalProjectCollection.GetLoadedProjects($project.FullName) |  % {
	$currentProject = $_

	$currentProject.Xml.Imports | ? {
		$targetFileName -ieq [System.IO.Path]::GetFileName($_.Project)
	}  | % {  
		$currentProject.Xml.RemoveChild($_)
	}
}