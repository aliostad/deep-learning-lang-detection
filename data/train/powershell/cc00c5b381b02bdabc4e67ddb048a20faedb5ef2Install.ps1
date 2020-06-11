param($installPath, $toolsPath, $package, $project)

$project.Properties.Item("PostBuildEvent").Value=@"
if NOT `$(ConfigurationName) == Release exit
cd `$(TargetDir)
powershell.exe -file "`$(ProjectDir)ProjectHost\deployment.ps1"
"@

$project.Save()