
# intended to run on a fresh machine using BoxStarter, initializes the machine
# to a basic developer environment, SoftwareCreations.devbox


# Power Script policy
Update-ExecutionPolicy Unrestricted

# Developer explorer options
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
# Activate Remote desktop
Enable-RemoteDesktop

# Visual studio Express, can be updated with a license key
#cinstm VisualStudioExpress2012Web

# Sql server Express, can be updated with a license key
#cinstm mssqlserver2012express

# Eclipse for java dev
#cinstm eclipse-java-juno 
#if(Test-PendingReboot){Invoke-Reboot}

# Other handy dev tools
cinst SoftwareCreations.devset 

# beef up IIS 
cinst IIS-WebServerRole -source windowsfeatures

# Taskbar console luncher
Install-ChocolateyPinnedTaskBarItem "$env:programfiles\console\console.exe"
copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'console.xml') -Force $env:appdata\console\console.xml
Install-ChocolateyPinnedTaskBarItem "$sublimeDir\sublime_text.exe"


#Install-WindowsUpdate -AcceptEula
if(Test-PendingReboot){Invoke-Reboot}

