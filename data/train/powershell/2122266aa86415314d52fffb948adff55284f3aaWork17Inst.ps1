#http://trycatchfail.com/blog/post/Painless-Workstation-Setup-with-Boxstarter.aspx

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart -EnableListDesktopAppsFirst -DisableSearchEverywhereInAppsView 
Set-CornerNavigationOptions -DisableUpperRightCornerShowCharms -DisableUpperLeftCornerSwitchApps -EnableUsePowerShellOnWinX

Enable-RemoteDesktop
Install-WindowsUpdate -acceptEula

#cinst GoogleChrome
#cinst 7zip.install

#install vmware workstation 10
#install synctoy

#Install-WindowsUpdate -acceptEula
