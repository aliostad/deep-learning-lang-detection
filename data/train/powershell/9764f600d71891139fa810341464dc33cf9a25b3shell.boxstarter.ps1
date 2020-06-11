# Updates a Windows machine and installs minimum configuration

# Show more info for files in Explorer
Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar

# Default to the desktop rather than application launcher
Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart -EnableShowStartOnActiveScreen -EnableShowAppsViewOnStartScreen -EnableSearchEverywhereInAppsView -EnableListDesktopAppsFirst

# Allow running PowerShell scripts
Update-ExecutionPolicy Unrestricted

# Allow unattended reboots
$Boxstarter.RebootOk=$true
$Boxstarter.AutoLogin=$true

Set-BoxstarterConfig -NugetSources "http://www.myget.org/F/jivkok-chocolatey/api/v2;http://chocolatey.org/api/v2;http://www.myget.org/F/boxstarter/api/v2"

cinst jivkok.shell -y
