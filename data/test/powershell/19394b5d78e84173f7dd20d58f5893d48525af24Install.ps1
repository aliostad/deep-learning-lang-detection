param($installPath, $toolsPath, $package, $project)

# Get the path to the web.config file
$xmlPath = $project.Properties.Item('FullPath').Value
$xmlPath = $xmlPath + 'web.config'

# Load up the web.config file
$xml = New-Object XML
$xml.Load($xmlPath)

# Look for a node for the .net 4.0 version of routing and remove it if found
write-host "Looking for the .net 4.0 version of System.Web.Routing"
$nodelist = $xml.selectnodes("/configuration/system.web/compilation/assemblies/add") # XPath is case sensitive
foreach ($testNode in $nodelist) {
  $assembly = $testNode.getAttribute("assembly")
  if ($assembly -match 'System.Web.Routing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35')
  {
    write-host "Removing the .net 4.0 version of System.Web.Routing"
    $testNode.ParentNode.RemoveChild($testNode)
    #Save back to web.config
    write-host "Saving updated web.config"
    $xml.Save($xmlPath)
    break
  }
}
