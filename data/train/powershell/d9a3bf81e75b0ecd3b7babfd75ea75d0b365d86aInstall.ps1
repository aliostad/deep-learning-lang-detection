param($installPath, $toolsPath, $package, $project)

# set 'Copy To Output Directory' to 'Copy if newer'

$project.ProjectItems.Item("phantomjs.exe").Properties.Item("CopyToOutputDirectory").Value = [int]2
$project.ProjectItems.Item("JavaScriptTests").ProjectItems.Item("foo.html").Properties.Item("CopyToOutputDirectory").Value = [int]2
$project.ProjectItems.Item("JavaScriptTests").ProjectItems.Item("foo.js").Properties.Item("CopyToOutputDirectory").Value = [int]2
$project.ProjectItems.Item("JavaScriptTests").ProjectItems.Item("bar.html").Properties.Item("CopyToOutputDirectory").Value = [int]2
$project.ProjectItems.Item("JavaScriptTests").ProjectItems.Item("bar.js").Properties.Item("CopyToOutputDirectory").Value = [int]2
$project.ProjectItems.Item("JavaScriptTests").ProjectItems.Item("Scripts").ProjectItems.Item("jquery-1.4.4-vsdoc.js").Properties.Item("CopyToOutputDirectory").Value = [int]2
$project.ProjectItems.Item("JavaScriptTests").ProjectItems.Item("Scripts").ProjectItems.Item("jquery-1.4.4.js").Properties.Item("CopyToOutputDirectory").Value = [int]2
$project.ProjectItems.Item("JavaScriptTests").ProjectItems.Item("Scripts").ProjectItems.Item("qunit.css").Properties.Item("CopyToOutputDirectory").Value = [int]2
$project.ProjectItems.Item("JavaScriptTests").ProjectItems.Item("Scripts").ProjectItems.Item("qunit.js").Properties.Item("CopyToOutputDirectory").Value = [int]2

$dte.ExecuteCommand("Build.RebuildSolution")