#First some common params, delivered by the nuget package installer
param($installPath, $toolsPath, $package, $project)


$buildProject = Get-MSBuildProject

. (Join-Path $toolsPath common.ps1)



$target = $buildProject.Xml.Targets | 
                   where { $_.Name -eq "Localization" }
if($target -ne $null)
{
    $buildProject.Xml.RemoveChild($target)
	Write-Host "Removed Localization!"
}

for ($i=0; $i -lt $filesArray.length; $i++)
{
	Delete-ProjectItem $filesArray[$i]
}


# Save the buildproject
$buildProject.Save()
# Save the project from the params
$project.Save()