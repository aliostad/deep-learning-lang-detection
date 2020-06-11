Set-ExecutionPolicy Unrestricted -Force

#Boxstarter options
$Boxstarter.RebootOk=$true

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions

Enable-RemoteDesktop

if (Test-PendingReboot) { Invoke-Reboot }

Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }

cinst -y javaruntime
cinst -y google-chrome-x64
cinst -y dropbox
cinst -y skype
cinst -y 7zip
cinst -y windirstat
cinst -y sumatrapdf
cinst -y vlc
cinst -y teamviewer
cinst -y PowerShell -pre
cinst -y PsGet -force
cinst -y github
cinst -y sysinternals
cinst -y wireshark

Install-Module ZLocation

Install-WindowsUpdate -acceptEula
if (Test-PendingReboot) { Invoke-Reboot }
