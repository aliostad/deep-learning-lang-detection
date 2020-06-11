$scriptDir = "C:\projects\Chocolatey Talk\Demo 1 - Install Using BoxStarter\" #$(Split-Path -parent $MyInvocation.MyCommand.Definition)

$showAllNotificationsInTaskBar = join-path -path "$scriptDir"  -childpath "SetTaskBarNotificationToShowAll.ps1"
& "$showAllNotificationsInTaskBar"


Enable-RemoteDesktop
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
Set-TaskbarSmall

cinst dotnet4.0 
cinst notepadplusplus 
# cinst TortoiseSVN 

 
Install-ChocolateyPinnedTaskBarItem "${env:SystemRoot}\system32\WindowsPowerShell\v1.0\powershell_ise.exe"
Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe"




if ((test-path "HKLM:\Software\TortoiseSVN") -eq $false) {
 write-host -foregroundColor Red "Error: Could not find TortoiseProc.exe"
 return
}

$tortoiseKey = get-itemproperty "HKLM:\Software\TortoiseSVN"

if ($tortoiseKey -eq $null) {
 write-host -foregroundColor Red "Error: Could not find TortoiseProc.exe"
 return
}

$tortoise = join-path -path $tortoiseKey.Directory  -childpath "bin\svn.exe"



if ($tortoise -eq $null) {
 write-host -foregroundColor Red "Error: Could not find svn.exe"
 return
}

$commandLine = '$tortoise checkout http://svn.com/myrepo/myproject c:\projects --username justin'
Write-Host $commandLine
#iex "& $commandLine"


Write-Host "If you have made it here without errors, you should be setup and ready to hack on the apps."
Write-Warning "If you see any failures happen, you may want to reboot and continue to let installers catch up. This script is idempotent and will only apply changes that have not yet been applied."