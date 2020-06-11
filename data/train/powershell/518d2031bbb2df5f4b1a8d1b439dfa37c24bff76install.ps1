param($installPath, $toolsPath, $package, $project)

$webItem = $null;

try{
	$webItem = $project.ProjectItems.Item("Web.config")
}
catch
{
}

try{
	if($webItem -eq $null)
	{
		$webItem = $project.ProjectItems.Item("web.config")
	}
}
catch
{
}

if($webItem -eq $null)
{
	$project.ProjectItems.Item("ClearScriptV8-32.dll").Properties.Item("CopyToOutputDirectory").Value = 1
	$project.ProjectItems.Item("ClearScriptV8-32.pdb").Properties.Item("CopyToOutputDirectory").Value = 1
	$project.ProjectItems.Item("ClearScriptV8-64.dll").Properties.Item("CopyToOutputDirectory").Value = 1
	$project.ProjectItems.Item("ClearScriptV8-64.pdb").Properties.Item("CopyToOutputDirectory").Value = 1
	$project.ProjectItems.Item("v8-ia32.dll").Properties.Item("CopyToOutputDirectory").Value = 1
	$project.ProjectItems.Item("v8-ia32.pdb").Properties.Item("CopyToOutputDirectory").Value = 1
	$project.ProjectItems.Item("v8-x64.dll").Properties.Item("CopyToOutputDirectory").Value = 1
	$project.ProjectItems.Item("v8-x64.pdb").Properties.Item("CopyToOutputDirectory").Value = 1
}

try{
	if($project.Object.References.Item('ClearScript.Installer') -ne $null)
	{	
		$project.Object.References.Item('ClearScript.Installer').Remove();
	}
}
catch{
	#don't really care if this step failed.
}