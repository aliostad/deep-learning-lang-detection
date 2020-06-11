param($installPath, $toolsPath, $package, $project)

$xml = New-Object xml

# find the App.xaml file
$config = $project.ProjectItems | where {$_.Name -eq "App.xaml"}

# find its path on the file system
$localPath = $config.Properties | where {$_.Name -eq "LocalPath"}

# load Web.config as XML
$xml.Load($localPath.Value)

$gasnode = $xml.SelectNodes("//*") | where { $_.Name -eq "GoogleAnalyticsService"}
if($gasnode -eq $null)
{
  $lto = $xml.SelectNodes("//*") | where { $_.Name -eq "Application.ApplicationLifetimeObjects"}
  $gas = $xml.CreateNode("element","analytics:GoogleAnalyticsService","clr-namespace:"+$project.Properties.Item("RootNamespace").Value+".Analytics")
  $gas.SetAttribute("WebPropertyId", "UA-12345-6")
  $lto.AppendChild($gas)
  # save the App.xaml file
  $xml.Save($localPath.Value)
}
