$psdir="C:\Users\chris.hey\Documents\GitHub\Powershell.SaveMeTime\Modules"
Write-Host $psdir
Get-ChildItem "$psdir\*.ps1" | %{.$_}
Write-Host "Custom modules loaded"

$p=$env:PSModulePath
$p += ";C:\Users\chris.hey\Documents\GitHub\Powershell.SaveMeTime"
[Environment]::SetEnvironmentVariable("PSModulePath",$p)

[Environment]::SetEnvironmentVariable("GitRepos","C:\Users\chris.hey\Documents\GitHub\")