Import-Module Boxstarter.Chocolatey
Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Enable-RemoteDesktop
Set-StartScreenOptions -EnableBootToDesktop -EnableSearchEverywhereInAppsView -EnableListDesktopAppsFirst
Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\WindowsPowerShell\v1.0\PowerShell_ISE.exe"
Install-ChocolateyPinnedTaskBarItem "$env:ProgramFiles\Notepad++\notepad++.exe"
Install-ChocolateyPinnedTaskBarItem "$env:ProgramFiles(x86)\Notepad++\notepad++.exe"
EXIT