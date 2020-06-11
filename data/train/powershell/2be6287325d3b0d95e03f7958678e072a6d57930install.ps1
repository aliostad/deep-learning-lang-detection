param($installPath, $toolsPath, $package, $project)

# Open a wiki page on package install if the HTTP handler hasn't been added to Web.Config, probably because Web.Config
# contains a custom handler already.

# The URL we load e.g. when the user installs in a non-web project.
$installHelpUrl = "https://github.com/provegard/Nancy.AspNet.WebSockets/wiki/Install-help"

# The URL we load when our custom HTTP handler wasn't installed.
$installFailedUrl = "https://github.com/provegard/Nancy.AspNet.WebSockets/wiki/Installation-unsuccessful"

# Default URL to show (none)
$showUrl = $null

try {
  # Find Web.Config in the project
  $webConfigItem = $project.ProjectItems | Where {$_.Name -eq "Web.config"} | Select -First 1
  if ($webConfigItem -ne $null) {
    # We have a Web.Config. Read it (we assume it's valid XML) and look for our custom HTTP handler.
    $path = $webConfigItem.Properties.Item("LocalPath").Value
    [xml]$xml = Get-Content $path
    $nodes = Select-Xml "//system.webServer/handlers/add[@type='Nancy.AspNet.WebSockets.WebSocketAwareHttpHandler']" $xml

    $wasInstalled = $nodes.Length -gt 0
    if (!$wasInstalled) {
      # Apparently the installation of our custom handler failed for some reason.
      $showUrl = $installFailedUrl
    }
  } else {
    # No Web.config file found. Did the user install in a non-web project?
    $showUrl = $installHelpUrl
  }
}
catch {
  # Something bad happened. Perhaps Web.config contained invalid XML??
  $showUrl = $installFailedUrl
}

if ($showUrl) {
  try {
    $dte2 = Get-Interface $dte ([EnvDTE80.DTE2])
    $dte2.ItemOperations.Navigate($showUrl) | Out-Null
  } catch {
    # Failed to load/show the URL. ♫ Let it go, let it go... ♫
  }
}

