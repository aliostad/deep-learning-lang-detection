
#
# analyze-media.ps1
# The main part of the Media Analyzer.
# Copyright (c) 2012 by Peter Störmer
#

#--- Path to Settings -----------------------------------------------------------

# Define where to find the settings file:
$settingsPath	= "$pwd"
$settingsFilename = "$settingsPath\analyze-iTunesMediaLib.config"

#--- Debug output -----
#$Env:path
#[AppDomain]::CurrentDomain.GetAssemblies()
#[AppDomain]::CurrentDomain.GetAssemblies() | ?{$_.fullname -like "taglib-sharp*"}


#--- Load external DLLs ----------------------------------------------------------

# Open the programming library that reads media file tags:
$pathToDev      = "$pwd"
$pathToTaglib   = "$pathToDev\lib\taglib-sharp-2.0.4.0-windows\Libraries"
$taglibFilename = "$pathToTagLib\taglib-sharp.dll"

[Reflection.Assembly]::LoadFrom( (Resolve-Path $taglibFilename) ) | out-null

#$pathToDotNetDLLs = "C:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727"
$pathToDotNetDLLs = "C:\WINDOWS\Microsoft.NET\Framework64\v4.0.30319"


# Web DLL for decoding of file names:
$SystemWebDllFilename = "$pathToDotNetDLLs\System.Web.dll"
[Reflection.Assembly]::LoadFrom( (Resolve-Path $SystemWebDllFilename) ) | out-null

# Drawing library:
$SystemDrawingDllFilename = "$pathToDotNetDLLs\System.Drawing.dll"
[Reflection.Assembly]::LoadFrom( (Resolve-Path $SystemDrawingDllFilename ) ) | out-null

# Windows forms library:
$SystemWindowsFormsDllFilename = "$pathToDotNetDLLs\System.Windows.Forms.dll"
[Reflection.Assembly]::LoadFrom( (Resolve-Path $SystemWindowsFormsDllFilename ) ) | out-null


#--- Include Functions -----------------------------------------------------------

. ".\includes\UtilityFunctions.ps1"
. ".\includes\iTunesMediaFileHandling.ps1"
. ".\includes\LyricsSearchFunctions.ps1"
. ".\includes\FindLyricsTabFunctions.ps1"
. ".\includes\AnalysisTabFunctions.ps1"
. ".\includes\MainDialog.ps1"
. ".\includes\LyricsSearchDialog.ps1"


#--- Start Main GUI Dialog -------------------------------------------------------

StartMainDialog $settingsFilename

