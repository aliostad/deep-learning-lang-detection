########################################################################
# File : update_sysinternals_suite.ps1
# Version : 1.0.3
# Purpose : Downloads and updates Sysinternals Suite tools.
# Synopsis: http://live.sysinternals.com/
#           http://technet.microsoft.com/en-us/sysinternals/bb842062.aspx
# Usage : .\update_sysinternals_suite.ps1
# Author: Leonard Lee <sheeeng@gmail.com>
########################################################################
# Version 1.0.2
# Fix compatibility with Windows PowerShell 4.0 environment.
# Version 1.0.3
# Use System.IO.Compression.FileSystem functions.
########################################################################
# References:
# Manage BITS (Background Intelligent Transfer Service) with Windows PowerShell
# http://technet.microsoft.com/en-us/magazine/ff382721.aspx
# Using Windows PowerShell to Create BITS Transfer Jobs
# http://msdn.microsoft.com/en-us/library/windows/desktop/ee663885(v=vs.85).aspx
# Copying Folders by Using the Shell Folder Object
# http://technet.microsoft.com/en-us/library/ee176633.aspx
########################################################################

Import-Module BitsTransfer

#$DebugPreference = "Continue" # show the debug message.
$DebugPreference = "SilentlyContinue" # not show the debug message.
#$DebugPreference = "Stop" # not show the debug message.
#$DebugPreference = "Inquire" # prompt the user.
Write-Debug "`$DebugPreference:`t $DebugPreference"

#(Get-Location).tostring() or [string](Get-Location)
#Write-Host "`$HOME.GetType():" $HOME.GetType()

#Set-Location $HOME
#$currentDirectory = $HOME

Set-Location -Path C:\Users\LeeL3
$currentDirectory = Get-Location

$zipFile = "SysinternalsSuite.zip"
$sourceZipFile = "$currentDirectory\$zipFile"
Write-Debug "`$sourceZipFile:`t`t $sourceZipFile"
$targetDirectory = "$currentDirectory\SysinternalsSuite"
Write-Debug "`$targetDirectory:`t $targetDirectory"

if (Test-Path -path $targetDirectory) {
    Write-Debug "The $targetDirectory directory exist."
    Write-Host "The $targetDirectory directory exist."
}
else {
    Write-Debug "Creating $targetDirectory directory since it does not exist."
    Write-Host "Creating $targetDirectory directory since it does not exist."
    New-Item -ItemType directory -Path $targetDirectory
}

Start-BitsTransfer -Source "http://download.sysinternals.com/files/SysinternalsSuite.zip"

$processName = "procexp*"
if (Get-Process $processName -ErrorAction SilentlyContinue) {
    Write-Debug "The $processName process exist. Stopping it."
    Write-Host "The $processName process exist. Stopping it."
    Stop-Process -processname $processName
}
else {
    Write-Debug "The $processName process does not exist."
}

#function Expand-ZIPFile($file, $destination)
#{
#    Write-Debug "`$file:`t`t`t $file"
#    Write-Debug "`$destination:`t $destination"
#    $shell = New-Object -ComObject Shell.Application
#    $zip = $shell.NameSpace($file)
#    foreach($item in $zip.items())
#    {
#        Write-Debug "`$item:`t`t`t $item" 
#        $shell.Namespace($destination).CopyHere($item, 0x14)
#    }
#}

[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
foreach($item in [IO.Compression.ZipFile]::OpenRead($sourceZipFile).Entries)
{
    Write-Debug "Extracting $item.FullName file."
    Write-Host Extracting $item.FullName file.
    [IO.Compression.ZipFileExtensions]::ExtractToFile($item, "$targetDirectory\$item", $true)
}

#Expand-ZIPFile -File $sourceZipFile $targetDirectory

Write-Host "Update completed." -ForegroundColor Yellow -BackgroundColor DarkGreen
$completedTime = Get-Date -Format o | foreach {$_ -replace ":", "."}
Write-Host $completedTime -ForegroundColor Yellow -BackgroundColor Black
Invoke-Item $targetDirectory

if ($Host.Name -eq "ConsoleHost")
{
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}

Write-Debug "End of script!"
Return
