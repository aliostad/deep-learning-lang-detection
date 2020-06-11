$machineName = 'dash'
$admin = (new-object Security.Principal.WindowsPrincipal(
            [Security.Principal.WindowsIdentity]::GetCurrent()
        )
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$scipt = $MyInvocation

if(!$admin)
{
	Start-Process powershell -ArgumentList "-noprofile -file $($MyInvocation.MyCommand)" -verb RunAs
}

Remove-Variable $script

# Set Computer Name
(Get-WmiObject Win32_ComputerSystem).Rename($machineName) | Out-Null
Remove-Variable $machineName

# Copy profile into place
Copy-Item profile.ps1 $PROFILE

### Explorer, Taskbar, System Tray
# Borrowed from https://github.com/addyosmani/dotfiles-windows/blob/master/windows.ps1

if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) 
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Type Folder | Out-Null
}

# Explorer: Show hidden files by default (1: Show Files, 2: Hide Files)
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# Explorer: show file extensions by default (0: Show Extensions, 1: Hide Extensions)
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Explorer: show path in title bar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1

# Explorer: Avoid creating Thumbs.db files on network volumes
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# TODO: Explore setting new W10 properties, e.g. colour, lockscreen wall/bg, multiple taskbar options
# TODO: Explore setting Edge properties, e.g. default search engine, etc
# TODO: OneGet ships standard with W10, explore using it and choco to install packages 