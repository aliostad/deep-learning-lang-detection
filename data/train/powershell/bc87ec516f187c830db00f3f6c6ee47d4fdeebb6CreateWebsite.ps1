$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\0-CommonInit.ps1"

# discover if there are required resources
Find-Module -DscResource xWebsite

# get the module
Install-Module xWebAdministration -Verbose -Force

# now start writing a configuration
psedit "$ScriptPath\Configuration.Website.1.ps1"

# configurations are like functions - so they can have parameters
# and help
psedit "$ScriptPath\Configuration.Website.2.ps1"

# Now you can invoke a configuration
psedit "$ScriptPath\Invoke-Website.ps1"

# This configuration can now be packaged in a module for sharing
psedit "$ScriptPath\..\WebsiteModule\WebsiteModule.psm1"

# Use Publish-Module to publish
$Host.ui.WriteLine('Enter API Key for publishing')
$ApiKey = $Host.UI.ReadLine()

Publish-Module -Path "$ScriptPath\..\WebsiteModule" -NuGetApiKey $ApiKey -Tags Configuration