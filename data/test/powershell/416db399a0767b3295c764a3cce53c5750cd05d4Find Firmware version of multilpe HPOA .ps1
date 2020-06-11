# Author : Ganesh Sekarbabu
# Site - https://techbrainblog.com/
# Purpose: To find the firmware version of the HP Enclosure Onboard Administrator and its releated components 
# Download the HP CMDLTS from the " http://www8.hp.com/us/en/products/server-software/product-detail.html?oid=5440657#!tab=features "
# By using this HP CMDLTS we can  Configure and manage insight Lights Out (iLO), HP BIOS and Onboard Administrator (OA)
# To run this script pls check the avilabilty of Get-HPOAFWSummary cmdlet
# Fimeware components - OnboardAdministratorFirmwareInformation , EnclosureComponentFirmwareInformation , InterconnectFirmwareInformation , DeviceFirmwareInformation
# Reference - http://techbrainblog.com/2015/12/27/powershell-to-find-the-firmware-version-of-the-hp-enclosure-onboard-administrator-and-its-related-components-part-1/
# Provide the text file path which contains the HP OA IPs
# Output of the firmware details will be stored in the given path for each Enclosure



$OA = Get-Content  (Read-host " Enter the path for the Text file contains OA IPs " )

Foreach ( $dd in $OA ) { 

$d = connect-HPOA $dd | Get-HPOAFWSummary 

$output1 = Read-Host " Enter the out-put location for store the DeviceFirmwareInformation [$dd]  "
$output2 = Read-Host " Enter the out-put location for store the EnclosureComponentFirmwareInformation [$dd] "
$output3 = Read-Host " Enter the out-put location for store the InterconnectFirmwareInformation [$dd]"
$output4 = Read-Host " Enter the out-put location for store the OnboardAdministratorFirmwareInformation [$dd]"





$d | Select-Object -ExpandProperty DeviceFirmwareInformation | Format-List -Property Bay,DeviceFWDetail > $output1

$d | Select-Object -ExpandProperty EnclosureComponentFirmwareInformation | Format-List -Property  Device,Name,Location,version > $output2

$d | Select-Object -ExpandProperty InterconnectFirmwareInformation | Format-List -Property Bay,DeviceModel,FirmwareVersion > $output3


$d | Select-Object -ExpandProperty OnboardAdministratorFirmwareInformation | Format-List > $output4

} 