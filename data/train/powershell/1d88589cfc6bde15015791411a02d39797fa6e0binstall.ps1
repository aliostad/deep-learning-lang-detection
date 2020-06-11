param($installPath, $toolsPath, $package, $project)

$projectItems = $project.ProjectItems

$imageItems = $projectItems.Item("Default").ProjectItems.Item("Images").ProjectItems

$tpBlank = $imageItems.Item("tp_blank.png")
$tpBlank.Properties.Item("BuildAction").Value = 0 # BuildAction = None
$tpBlank.Properties.Item("CopyToOutputDirectory").Value = 2 # CopyToOutputDirectory = Copy if newer

$dkBlank = $imageItems.Item("dk_disabled.png")
$dkBlank.Properties.Item("BuildAction").Value = 0 # BuildAction = None
$dkBlank.Properties.Item("CopyToOutputDirectory").Value = 2 # CopyToOutputDirectory = Copy if newer
