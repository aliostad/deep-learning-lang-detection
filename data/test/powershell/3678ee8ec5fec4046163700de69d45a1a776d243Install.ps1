param($installPath, $toolsPath, $package, $project)

write-host "Artifactory Package Install Script starting"

$rootDir = (Get-Item $installPath)
$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])
$solutionDirectory = Split-Path -parent $solution.FileName
$artifactoryDir = join-path $solutionDirectory '\.artifactory'
$packageVersion = $package.version.toString()

Function dynamicVersioning(){
	# Updating the current version of the plugin
	$taskPath = join-path $solutionDirectory '\.artifactory\Deploy.targets'
	
	$taskDoc = New-Object xml
	$taskDoc.psbase.PreserveWhitespace = true
	$taskDoc.Load($taskPath)
	
	$taskDoc.Project.PropertyGroup[0].pluginVersion = $packageVersion
	$taskDoc.LoadXml($taskDoc.OuterXml)
	$taskDoc.Save($taskPath)
}

Function Install()
{
	write-host "Recognize first installation state"

	# Updating the current version of the plugin
	dynamicVersioning	
} 


Function Update()
{
	write-host "Recognize Update Mode"
	
	# Updating the current version of the plugin
	dynamicVersioning
} 

#[System.Windows.Forms.MessageBox]::Show("We are proceeding with next step.") 


# Verifying that we are inside "Update" process.
if((Test-Path $artifactoryDir )){
	
	$taskPath = join-path $solutionDirectory '\.artifactory\Deploy.targets'
	
	$taskDoc = New-Object xml
	$taskDoc.psbase.PreserveWhitespace = true
	$taskDoc.Load($taskPath)
	$currentVersion = $taskDoc.Project.PropertyGroup[0].pluginVersion
	
	if($packageVersion -gt $currentVersion)
	{
		#[System.Windows.Forms.MessageBox]::Show("Install => Update") 
		$taskDoc.Save($taskPath)
		Update
	}
	else
	{
		#[System.Windows.Forms.MessageBox]::Show("Install => Install") 
		$taskDoc.Save($taskPath)
		Install
	}
}
else{
	#[System.Windows.Forms.MessageBox]::Show("Install => Install") 
	Install
}

write-host "Artifactory Package Install Script ended"