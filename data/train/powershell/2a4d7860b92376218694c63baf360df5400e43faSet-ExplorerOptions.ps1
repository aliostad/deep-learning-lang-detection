function Set-ExplorerOptions {
<#
.SYNOPSIS
Sets options on the windows Explorer shell

.PARAMETER showHidenFilesFoldersDrives
If this switch is set, hidden files will be shown in windows explorer

.PARAMETER showProtectedOSFiles
If this flag is set, hidden Operating System files will be shown in windows explorer

.PARAMETER showFileExtensions
Setting this switch will cause windows explorer to include the file extension in file names

.PARAMETER bootToDesktop
Setting this switch will cause Windows to boot into the deskotp rather than the start page (Windows 8.1 required)

.PARAMETER hideTouchKeyboard
Setting this switch will hide the Touch Keyboard item on the task bar (Windows 8.1 required)

.LINK
http://boxstarter.codeplex.com

#>    
    param(
        [switch]$showHidenFilesFoldersDrives, 
        [switch]$showProtectedOSFiles, 
        [switch]$showFileExtensions,
        [switch]$bootToDesktop,
        [switch]$hideTouchKeyboard
    )
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    if($showHidenFilesFoldersDrives) {Set-ItemProperty $key Hidden 1}
    if($showFileExtensions) {Set-ItemProperty $key HideFileExt 0}
    if($showProtectedOSFiles) {Set-ItemProperty $key ShowSuperHidden 1}
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage'
    if($bootToDesktop) {Set-ItemProperty $key OpenAtLogon 0}
    
    if($hideTouchKeyboard) 
    {
        $key = 'HKCU:\Software\Microsoft\Windows\TabletTip\1.7'
        if(!(Test-Path $key))
        {
            New-Item -Path $key -Force | Out-Null
            New-ItemProperty -Path $key -Name HideTipband -Value 1 | Out-Null
        }
        else
        {
            Set-ItemProperty $key HideTipband 1
        }
    }
    Restart-Explorer
}
