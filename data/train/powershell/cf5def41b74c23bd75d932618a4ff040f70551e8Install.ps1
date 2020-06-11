param($installPath, $toolsPath, $package, $project)

#$project = Get-Project

# make all files in Dependency folder 'CopyIfNewer' to Output Dir
$project.ProjectItems.Item("bin32").ProjectItems | Where { $_.Name -like '*.dll' } | 
    foreach {
        Write-Host processing dependency: $_.Name    
        $_.Properties.Item("CopyToOutputDirectory").Value = 2
        $_.Properties.Item("BuildAction").Value = 0 
    }
$project.ProjectItems.Item("bin64").ProjectItems | Where { $_.Name -like '*.dll' } | 
    foreach {
        Write-Host processing dependency: $_.Name    
        $_.Properties.Item("CopyToOutputDirectory").Value = 2
        $_.Properties.Item("BuildAction").Value = 0 
    }
