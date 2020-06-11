param($installPath, $toolsPath, $package, $project)

# set lmfit32 build options
$lmfit = $project.ProjectItems.Item("lmfit32").ProjectItems.Item("lmfit.dll")
if ($project.Type -eq "F#") {
    $lmfit.Properties.Item("BuildAction").Value = [Microsoft.VisualStudio.FSharp.ProjectSystem.BuildAction]::None
}
else {
    $lmfit.Properties.Item("BuildAction").Value = 0 # None
}
$lmfit.Properties.Item("CopyToOutputDirectory").Value = 1 # CopyToOutputDirectory = Copy always

# set lmfit64 build options
$lmfit = $project.ProjectItems.Item("lmfit64").ProjectItems.Item("lmfit.dll")
if ($project.Type -eq "F#") {
    $lmfit.Properties.Item("BuildAction").Value = [Microsoft.VisualStudio.FSharp.ProjectSystem.BuildAction]::None
}
else {
    $lmfit.Properties.Item("BuildAction").Value = 0 # None
}
$lmfit.Properties.Item("CopyToOutputDirectory").Value = 1 # CopyToOutputDirectory = Copy always
