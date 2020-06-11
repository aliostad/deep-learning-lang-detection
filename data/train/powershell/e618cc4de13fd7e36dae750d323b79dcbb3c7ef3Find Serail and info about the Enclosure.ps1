# Author : Ganesh Sekarbabu
# Site - https://techbrainblog.com/
# Purpose:  The Get-HPOAEnclosureInfo cmdlet gets enclosure information. The following enclosure details are displayed:
#    - Enclosure name
#    - Enclosure type
#    - Onboard Administrator hardware version
#    - Enclosure Rack U Position
#    - Enclosure part number
#    - Serial number
#    - Asset tag
#    - Onboard Administrator MAC address
# Download the HP CMDLTS from the " http://www8.hp.com/us/en/products/server-software/product-detail.html?oid=5440657#!tab=features "
# By using this HP CMDLTS we can  Configure and manage insight Lights Out (iLO), HP BIOS and Onboard Administrator (OA)
# To run this script pls check the avilabilty of Get-HPOAEnclosureInfo cmdlet
# Reference - http://techbrainblog.com/2016/01/04/powershell-script-to-find-the-hp-enclosure-information/
# Provide the text file path which contains the HP OA IPs




$OA = Get-content (Read-host " Enter the path of the TXT file contains HP OA IPs  ")

connect-HPOA $OA | Get-HPOAEnclosureInfo | Select-Object IP,EnclosureName,EnclosureType,PartNumber,SerialNumber