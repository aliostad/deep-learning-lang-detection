#Initial windows configuration

Update-ExecutionPolicy Unrestricted
Enable-MicrosoftUpdate
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

#Runtimes and frameworks
cinst dotnet4.0
cinst dotnet4.5
cinst dotnet4.5.1
cinst dotnet4.5.2
cinst javaruntime
cinst nodejs.install
#cinst ruby
#cinst python
#cinst golang

#Windows enhancements and helpers
#cinst classic-shell
#cinst webpi
#cinst ConEmu
#cinst ransack

#Web browsers
#cinst GoogleChrome
cinst GoogleChrome.Canary
cinst Firefox
#cinst safari

#Browser plugins
#cinst fiddler4

#Text editors
cinst SublimeText3
cinst SublimeText3.PackageControl

#Utilities
#cinst dotPeek
#cinst 7zip
cinst greenshot
cinst googledrive
cinst sysinternals
#cinst filezilla
cinst paint.net
cinst linqpad
cinst spotify
cinst f.lux

#Visual studio and plugins
cinst visualstudio2015community -InstallArguments "/Features:'WebTools SQL'"
cinst resharper
#cinst VS2013.VSCommands
#cinst visualstudio2013-webessentials.vsix

#VCS
cinst gitextensions
#cinst kdiff3
cinst p4merge

#Databases
choco install mongodb
choco install robomongo

#other
cinst arduino
cinst visualstudiocode
cinst windirstat

#Install windows updates
Install-WindowsUpdate -AcceptEula
