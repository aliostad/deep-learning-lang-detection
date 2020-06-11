# Author : Ganesh Sekarbabu
# Site - https://techbrainblog.com/
# Purpose:  The Get-HPOABladeDeviceSerialNumber cmdlet gets the specified direct attached blade device serial number
# Download the HP CMDLTS from the " http://www8.hp.com/us/en/products/server-software/product-detail.html?oid=5440657#!tab=features "
# By using this HP CMDLTS we can  Configure and manage insight Lights Out (iLO), HP BIOS and Onboard Administrator (OA)
# To run this script pls check the avilabilty of Get-HPOABladeDeviceSerialNumber cmdlet
# Reference - http://techbrainblog.com/2016/01/04/powershell-script-to-get-the-specified-direct-attached-blade-device-serial-number/
# Provide the HP OA IP\Name


$OA = Read-host " Enter the HP OA IP or Name "
$bay = Read-host " Enter the Bay Number ( 1 , 1-2 ) "

connect-HPOA $OA | Get-HPOABladeDeviceSerialNumber -Bay $bay | Select-Object -Property Blade 

