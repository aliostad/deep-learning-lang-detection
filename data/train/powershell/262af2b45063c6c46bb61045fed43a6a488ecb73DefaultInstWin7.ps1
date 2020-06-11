#http://trycatchfail.com/blog/post/Painless-Workstation-Setup-with-Boxstarter.aspx

#install ie11 first, else it won't work because an missing update

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar

Enable-RemoteDesktop
Install-WindowsUpdate -acceptEula

cinst DotNet4.5
cinst DotNet3.5
cinst jre8
cinst 7zip.install
cinst vlc
cinst iTunes

cinst flashplayeractivex
cinst adobereader

Install-WindowsUpdate -acceptEula

