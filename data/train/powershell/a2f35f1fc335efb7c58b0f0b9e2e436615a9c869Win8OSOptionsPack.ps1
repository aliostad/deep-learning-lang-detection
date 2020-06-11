#Get project directory name
$projectPackage = $(Get-Location | Split-Path -Leaf)
$packageInstallText = $projectPackage + ' software package'

if (Install-NeededFor $packageInstallText) 
{
	#Check if chocolatey is installed 
	if( Install-ChocoOnlyIfNotPreviouslyInstalled )
	{
		# Could call other install scrtips here or call cinst package or Import Boxstarter and install
  		#& another.ps1
  		#cinst packages.config -y
  		#

Write-Host "Installing Windows OS features and settings." -ForegroundColor Yellow

Write-Host "Set options for the Windows Corner Navigation in Windows 8/8.1"
#Set-CornerNavigationOptions -EnableUpperRightCornerShowCharms -EnableUpperLeftCornerSwitchApps -EnableUsePowerShellOnWinX

Write-Host "Set options on the Windows Taskbar"
Set-TaskbarOptions -Size Small -Lock -Dock Top

Write-Host "Set options for the Windows Corner Navigation in Windows 8/8.1"
Set-CornerNavigationOptions -EnableUpperRightCornerShowCharms -EnableUpperLeftCornerSwitchApps -EnableUsePowerShellOnWinX
#Set-CornerNavigationOptions -DisableUpperRightCornerShowCharms -DisableUpperLeftCornerSwitchApps -DisableUsePowerShellOnWinX

Write-Host "Configure Windows OS settings." -ForegroundColor Yellow
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

Write-Host "Install Windows OS IIS features." -ForegroundColor Yellow
cinst IIS-WebServerRole -source windowsfeatures
cinst IIS-HttpCompressionDynamic -source windowsfeatures
cinst TelnetClient -source windowsFeatures
cinst Microsoft-Hyper-V-All -source windowsFeatures
Enable-RemoteDesktop

Write-Host "Pin apps to taskbar." -ForegroundColor Yellow
Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\mstsc.exe"
Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\msconfig.exe"

Write-Host "Run windows updates." -ForegroundColor Yellow
#Install-WindowsUpdate -AcceptEula


	}else
	{
		write-host 'We have encountered a problem installing Chocolatey'
	}
  
}else
{
  write-host 'Installation cancelled'
}