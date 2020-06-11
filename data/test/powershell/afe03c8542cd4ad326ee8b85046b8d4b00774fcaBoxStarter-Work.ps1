# To Run From Web:  http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/jquintus/QuintusInstall/master/BoxStarter-Work.ps1

#### Boxstarter options
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

# Windows Options
Set-TaskbarOptions -lock
Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart -EnableShowStartOnActiveScreen
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
Enable-RemoteDesktop

# Must Have Toys
cinst -y KickAssVim
cinst -y greenshot # Keep this before Dropbox to make sure we get the print screen hooks registered
cinst -y keepass
cinst -y cmder.portable

# Less Important Toys
cinst -y 7zip.install
cinst -y sysinternals
cinst -y binroot
cinst -y winmerge
cinst -y dropbox
cinst -y git
cinst -y SourceTree
cinst -y GnuWin
cinst -y spotify
cinst -y paint.net
cinst -y markdownpad2
