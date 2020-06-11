####################
# Basic MEAN stack #
####################

###### NOTES #######
# MongoDB is currently a bit buggy - it will show a bunch of access denied messages and take a while, but will ultimately work.
# MongoDB will be started as a Windows Service during install. 

# region Basic Windows Config
# See more at http://boxstarter.org/WinConfig
Set-StartScreenOptions -EnableBootToDesktop -EnableListDesktopAppsFirst -EnableSearchEverywhereInAppsView
Enable-RemoteDesktop
Install-WindowsUpdate -AcceptEula
Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar


# region Browsers
# Basic requirements
cinst git
cinst firefox
cinst googlechrome
cinst fiddler4

# region MEAN

cinst mongodb # This installs mongodb2.4
cinst nodejs.install
npm install -g angular
npm install -g express

# Personal choice of modules
# npm install -g forever
# npm install -g nodemon
# npm install -g eslint

# Editor - choose one or more
# cinst sublimetext3
# cinst atom
# cinst vim
# cinst visualstudio2013expressweb  -InstallArguments "/Features:'WebTools'
