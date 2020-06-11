# Author : Ganesh Sekarbabu
# Site - https://techbrainblog.com/
# Purpose:  The Get-HPOAEnclosureFan cmdlet gets information and current status of the specified enclosure fan
# Download the HP CMDLTS from the " http://www8.hp.com/us/en/products/server-software/product-detail.html?oid=5440657#!tab=features "
# By using this HP CMDLTS we can  Configure and manage insight Lights Out (iLO), HP BIOS and Onboard Administrator (OA)
# To run this script pls check the avilabilty of Get-HPOAEnclosureFan cmdlet
# Reference - http://techbrainblog.com/2016/01/03/powershell-script-to-find-the-current-status-of-the-specified-hp-enclosure-fan/
# Provide the HP OA IP\Name

$OA = Read-host " Enter the HP OA IP or Name "

connect-HPOA $OA | Get-HPOAEnclosureFan