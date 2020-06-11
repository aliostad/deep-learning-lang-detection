# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#
# Description: Copies files needed for Umpqua Themes. Used by Unattend.xml to set.
# Author: jamescradit
# Date: 7/30/2013
# Version: 1.0
# Changelog: 1.0 - Initial Version
#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\



$tsEnv = New-Object -ComObject Microsoft.SMS.TSEnvironment

$DrivePath = $tsEnv.Value("OSDTargetSystemDrive")
$Path = $DrivePath + "\ProgramData\Umpqua\ClientEngineering\Theme"


Copy-Item umpquadesktop.jpg -Destination $Path -Force
Copy-Item umpquaicon.png -Destination $Path -Force
