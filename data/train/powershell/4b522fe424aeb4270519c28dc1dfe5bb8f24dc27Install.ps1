param($installPath, $toolsPath, $package, $project)

# Core stuff
$file1 = $project.ProjectItems.Item("Samples").ProjectItems.Item("GrinderScript.Net").ProjectItems.Item("Core").ProjectItems.Item("ScriptEngineThatCreateWorkerByCtor.grinder.properties")
$file2 = $project.ProjectItems.Item("Samples").ProjectItems.Item("GrinderScript.Net").ProjectItems.Item("Core").ProjectItems.Item("WorkerThatThrowsExceptionAtRandom.grinder.properties")

# Data pool stuff
$file3 = $project.ProjectItems.Item("Samples").ProjectItems.Item("GrinderScript.Net").ProjectItems.Item("Datapool").ProjectItems.Item("Credentials.csv")
$file4 = $project.ProjectItems.Item("Samples").ProjectItems.Item("GrinderScript.Net").ProjectItems.Item("Datapool").ProjectItems.Item("Datapool.grinder.properties")
$file5 = $project.ProjectItems.Item("Samples").ProjectItems.Item("GrinderScript.Net").ProjectItems.Item("Datapool").ProjectItems.Item("Scenario.grinder.properties")

# CsScript stuff
$file6 = $project.ProjectItems.Item("Samples").ProjectItems.Item("GrinderScript.Net").ProjectItems.Item("CsScript").ProjectItems.Item("CsScript.grinder.properties")
$file7 = $project.ProjectItems.Item("Samples").ProjectItems.Item("GrinderScript.Net").ProjectItems.Item("Core").ProjectItems.Item("WorkerThatLogs.cs")

# set 'Copy To Output Directory' to 'Copy if newer'
$copyToOutput1 = $file1.Properties.Item("CopyToOutputDirectory")
$copyToOutput1.Value = 2

$copyToOutput2 = $file2.Properties.Item("CopyToOutputDirectory")
$copyToOutput2.Value = 2

$copyToOutput3 = $file3.Properties.Item("CopyToOutputDirectory")
$copyToOutput3.Value = 2

$copyToOutput4 = $file4.Properties.Item("CopyToOutputDirectory")
$copyToOutput4.Value = 2

$copyToOutput5 = $file5.Properties.Item("CopyToOutputDirectory")
$copyToOutput5.Value = 2

$copyToOutput6 = $file6.Properties.Item("CopyToOutputDirectory")
$copyToOutput6.Value = 2

$copyToOutput7 = $file7.Properties.Item("CopyToOutputDirectory")
$copyToOutput7.Value = 2
