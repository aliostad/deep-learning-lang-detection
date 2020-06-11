param($installPath, $toolsPath, $package, $project)

# find dll file in project and change it's CopyToOutputDirectory property to Copy If Newer
(($project.ProjectItems | ?{ $_.Name -eq "libOpenCvSharpExtern.dll" }).Properties | ?{ $_.Name -eq "CopyToOutputDirectory" }).Value = 2
(($project.ProjectItems | ?{ $_.Name -eq "OpenCvSharpExtern.dll" }).Properties | ?{ $_.Name -eq "CopyToOutputDirectory" }).Value = 2
# find config file in project and change it's CopyToOutputDirectory property to Copy If Newer
(($project.ProjectItems | ?{ $_.Name -match ".*\.dll\.config" }).Properties | ?{ $_.Name -eq "CopyToOutputDirectory" }).Value = 2