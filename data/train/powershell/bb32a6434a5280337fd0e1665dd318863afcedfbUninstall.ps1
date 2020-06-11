param($installPath, $toolsPath, $package, $project)

. "$toolsPath\ProjectFileTransform.ps1"

if ($project -eq $null) { Exit }

# Check if this is the last remaining NuGet package for the project
$projectPath = Split-Path -Parent $project.FileName
$packagesXml = [XML] (gc "$projectPath\packages.config")

if ($packagesXml.packages.SelectNodes("package[@id!='$($package.Id)']").Count -eq 0) {
  MessageBox "In order to ensure clean package uninstallation, you should DISCARD changes to the project when prompted" "Uninstall" 0 64
  # Make the changes to the project file which are normally done automatically, because
  # those changes are to be discarded by the user.
  $project.ProjectItems | Where { $_.Name -eq "packages.config" } | ForEach-Object { $_.Remove() }
}

# Save any current changes to project and update imports
$project.Save()
$xml = [XML] (gc $project.FullName)
RestoreProjectFile $installPath $toolsPath $package $xml
$projName = $project.FullName
$xml.Save($projName)
