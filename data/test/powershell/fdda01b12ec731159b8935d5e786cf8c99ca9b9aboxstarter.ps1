
$username = [Security.Principal.WindowsIdentity]::getcurrent().name

#windows settings
Disable-InternetExplorerESC
Enable-MicrosoftUpdate
Install-WindowsUpdate -Full

Move-LibraryDirectory "Personal" "d:\Users\$username\Documents"
Move-LibraryDirectory "Music" "d:\Users\$username\Music"
Move-LibraryDirectory "Video" "d:\Users\$username\Video"

Set-StartScreenOptions -EnableBootToDesktop     
			-EnableDesktopBackgroundOnStart
			-EnableShowStartOnActiveScreen
			-EnableShowAppsViewOnStartScreen
			-EnableSearchEverywhereInAppsView
			-EnableListDesktopAppsFirst

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives
			-DisableShowProtectedOSFiles
			-EnableShowFileExtensions
			-DisableShowFullPathInTitleBar

Set-TaskbarOptions -Size Large -Lock -Dock Bottom

cinst IIS-WebServerRole -source windowsfeatures
cinst IIS-HttpCompressionDynamic -source windowsfeatures
cinst IIS-ManagementScriptingTools -source windowsfeatures
cinst IIS-WindowsAuthentication -source windowsfeatures

cinst linqpad4
cinst NugetPackageExplorer
cinst git.install -params '"/NoAutoCrlf"'
cinst TortoiseGit
cinst nodejs.install
cinst fiddler4
cinst sublimetext3
cinst sublimetext3.packagecontrol
cinst conemu
cinst yeoman

#programming languages
cinst erlang
cinst golang

#browsers
cinst googlechrome
cinst firefox

#other essential tools
cinst 7zip.install
cinst adobereader
cinst vlc
cinst skype
cinst fillezilla
cinst paint.net
cinst keepass.install

# VS
cinst visualstudio2013ultimate -InstallArguments 
    "/Features:'WebTools SQL Blend Win8SDK' 
     /ProductKey:SOME_KEY"
#Install-ChocolateyVsixPackage WebEssentials2013 http://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/31/WebEssentials2013.vsix