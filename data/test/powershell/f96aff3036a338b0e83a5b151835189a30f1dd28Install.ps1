param($installPath, $toolsPath, $package, $project)

$buildProject = Get-MSBuildProject $project.ProjectName

$projectRootDirectory = Split-Path $project.FileName -parent

Set-Location $projectRootDirectory

$toolsRelativePath = Resolve-Path $toolsPath -relative

Set-Location $toolsPath

$projectRelativePath = Resolve-Path $projectRootDirectory -relative

$target = $buildProject.Xml.AddProperty("StartAction", "Program")
$target = $buildProject.Xml.AddProperty("StartProgram", '$(MSBuildProjectDirectory)\' + $toolsRelativePath + '\Rosalia.exe')
$target = $buildProject.Xml.AddProperty("StartWorkingDirectory", '$(MSBuildProjectDirectory)\' + $toolsRelativePath)
$target = $buildProject.Xml.AddProperty("StartArguments", '/hold ' + $projectRelativePath + '\bin\$(Configuration)\' + $project.Name + '.dll')

$buildProject.Save()
$project.Save()