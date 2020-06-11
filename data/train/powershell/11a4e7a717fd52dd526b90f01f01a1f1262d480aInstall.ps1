# Install.ps1
param($installPath, $toolsPath, $package, $project)

$xml = New-Object xml

# find the Web.config file
$config = $project.ProjectItems | where {$_.Name -eq "packages.config"}

# find its path on the file system
$localPath = $config.Properties | where {$_.Name -eq "LocalPath"}

# load Web.config as XML
$xml.Load($localPath.Value)

# select the node
$node = $xml.SelectSingleNode("packages")

# change the connectionString value
$node.SetAttribute("perforce-friendly", "yes")

# save the Web.config file
$xml.Save($localPath.Value)