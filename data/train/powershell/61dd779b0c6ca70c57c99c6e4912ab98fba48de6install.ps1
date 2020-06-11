param($installPath, $toolsPath, $package, $project)

## Set property: CopyToOutputDirectory
$folder = $project.ProjectItems.Item("x86")
if ($folder -ne $null) {
    $item = $folder.ProjectItems.Item("lz4X86.dll")
    if ($item -ne $null) {
        $property = $item.Properties.Item("CopyToOutputDirectory")
        if ($property -ne $null) {
            $property.Value = 1    
        }
    }
}

$folder = $project.ProjectItems.Item("x64")
if ($folder -ne $null) {
    $item = $folder.ProjectItems.Item("lz4X64.dll")
    if ($item -ne $null) {
        $property = $item.Properties.Item("CopyToOutputDirectory")
        if ($property -ne $null) {
            $property.Value = 1    
        }
    }
}
