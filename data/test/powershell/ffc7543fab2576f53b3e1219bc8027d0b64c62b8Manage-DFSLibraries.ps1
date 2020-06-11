### APPLICATION: Manage-DFSLibraries
### VERSION: 2.0.0
### DATE: June 10, 2015
### AUTHOR: Johan Cyprich
### AUTHOR URL: www.cyprich.com
### AUTHOR EMAIL: jcyprich@live.com
###   
### LICENSE:
### The MIT License (MIT)
### http://opensource.org/licenses/MIT
###
### Copyright (c) 2015 Johan Cyprich. All rights reserved.
###
### Permission is hereby granted, free of charge, to any person obtaining a copy 
### of this software and associated documentation files (the "Software"), to deal
### in the Software without restriction, including without limitation the rights
### to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
### copies of the Software, and to permit persons to whom the Software is
### furnished to do so, subject to the following conditions:
###
### The above copyright notice and this permission notice shall be included in
### all copies or substantial portions of the Software.
###
### THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
### IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
### FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
### AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
### LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
### OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
### THE SOFTWARE.
###
### SUMMARY:
### Backs up and restores from backup the Settings.xml file in DFS 3.x which contain the libraries
### of the planrooms
###
### In Window XP, Settings.xml is in $env:USERPROFILE + "\Local Settings\temp\PDM\".
### In Windows 7+, Settings.xml is in $env:USERPROFILE + "\AppData\Local\Temp\PDM\".

param
(
  [string] $cmd,              # command line parameter
  [string] $os                # operating system other than default
)


#=[ SETTINGS ]======================================================================================

$xml = [xml](get-content $PSScriptRoot\Settings.xml)


#=[ GLOBALS ]=======================================================================================

[string] $global:settingsPath = $env:USERPROFILE + $xml.Settings.Paths.SettingsPath

# path for DFS settings on Windows XP
[string] $global:settingsXPPath = $env:USERPROFILE + $xml.Settings.Paths.SettingsXPPath

# path to save DFS settings
[string] $global:savePath = $xml.Settings.Paths.SavePath


#=[ FUNCTIONS ]=====================================================================================


####################################################################################################
### SUMMARY:
### Display help screen when user enters "?" or "help".
###
### PARAMETERS:
### $global:cmd (in) - Command line parameters.
####################################################################################################

function DisplayHelp
{
  if (($cmd -eq "?") -or ($cmd -eq "help") -or ($cmd -eq ""))
  {
    Write-Host "Backup and restore utility for settings in DFS 3.x."
    Write-Host ""
    Write-Host " Usage: Manage-DFSLibraries1 [SAVE | RESTORE]"
    Write-Host "   where SAVE will copy the settings to the specified path in the configuration file and"
    Write-Host "   RESTORE will copy saved settings to the PDM folder."
    Write-Host ""    
    Write-Host " Example: .\Manage-DFSLibraries.ps1 restore"
    Write-Host ""

    break  
  }
} # DisplayHelp


####################################################################################################
### SUMMARY:
### Writes the name of the app, copyright, license, and branding.
###
### PARAMETERS:
### $appName (in) - Name of the app.
### $copyright (in) -  Year and copyright name.
### $appFore (in) - Foreground colour of $appName (default White).
### $appBack (in) - Background colour of $appName (default DarkBlue).
### $copyFore (in) - Foreground colour of $copyright (default Black).
### $copyBlack (in) - Background colour of $copyright (default DarkGray).
####################################################################################################

function WriteProgramInfo
{
  param
  (
    [string] $appName, 
    [string] $copyright,
    [string] $appFore = "White",
    [string] $appBack = "DarkBlue",
    [string] $copyFore = "Black",
    [string] $copyBack = "DarkGray"    
  )
  
  [string] $copyrt = " Copyright (C) $copyright. All rights reserved. "
  [string] $license = " Licensed under The MIT License (MIT)."
  [int] $copyrtLength = $copyrt.length
  [string] $linePadding
  [string] $emptyLine = " " * $copyrtLength  
  
  # Write app info and pad with spaces based on the length of the copyright line.
  
  Write-Host ""
  Write-Host $emptyLine -ForegroundColor $appFore -BackgroundColor $appBack
  
  $linePadding = " " * ($copyrtLength - " $appName".length)
  Write-Host " $appName$linePadding" -ForegroundColor $appFore -BackgroundColor $appBack
  
  Write-Host $emptyLine -ForegroundColor $appFore -BackgroundColor $appBack
  Write-Host $emptyLine -ForegroundColor $copyFore -BackgroundColor $copyBack
  Write-Host $copyrt -ForegroundColor $copyFore -BackgroundColor $copyBack
  
  $linePadding = " " * ($copyrtLength - " $license".length)
  Write-Host " Licensed under The MIT License (MIT). $linePadding" -ForegroundColor $copyFore -BackgroundColor $copyBack

  Write-Host $emptyLine -ForegroundColor $copyFore -BackgroundColor $copyBack
  Write-Host ""
} # WriteProgramInfo


#=[ MAIN ]==========================================================================================


[string] $source

WriteProgramInfo "Manage-DFSLibraries 2.0.0" "2015 Johan Cyprich"
DisplayHelp

# Backup or restore settings.

if ($cmd -eq "save")
{
  $source = $global:settingsPath + "\Settings.xml"

  if ($os -eq "xp")
  {
    Write-Host "Back up Settings.xml.."
    Copy-Item -Path $source -Destination $global:savePath
  }
  
  else
  {
    Write-Host "Backup up Settings.xml"
    Copy-Item -Path $source -Destination $global:savePath
  }
}

elseif ($cmd -eq "restore")
{
  $source = $global:savePath + "\Settings.xml"

  if ($os -eq "xp")
  {
    Write-Host "Restore Settings.xml."
    Copy-Item -Path $source -Destination $global:settingsXPPath
  }
  
  else
  {
    Write-Host "Restore Settings.xml."
    Copy-Item -Path $source -Destination $global:settingsPath
  }
}

else
{
  Write-Host "Unknown command."
}

Write-Host ""

# Close the program.

Write-Host " Done " -ForegroundColor White -BackgroundColor Red
Write-Host ""
