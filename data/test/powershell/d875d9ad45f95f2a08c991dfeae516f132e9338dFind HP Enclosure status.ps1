# Author : Ganesh Sekarbabu
# Site - https://techbrainblog.com/
# Purpose: To find multilple HP Enclosure basic healt and Status ( OnboardAdministrator,Powersubsystem,Coolingsubsystem)
# Download the HP CMDLTS from the " http://www8.hp.com/us/en/products/server-software/product-detail.html?oid=5440657#!tab=features "
# By using this HP CMDLTS we can  Configure and manage insight Lights Out (iLO), HP BIOS and Onboard Administrator (OA)
# To run this script pls check the avilabilty of Get-HPOAEnclosureStatus cmdlet
# Reference - http://techbrainblog.com/2016/01/02/powershell-script-to-find-the-basic-health-and-status-of-the-hp-enclosure/
# Provide the text file path which contains the HP OA IPs





$OA = Get-content (Read-host " Enter the path of the TXT file contains HP OA IPs  ")

connect-HPOA $OA | Get-HPOAEnclosureStatus | Select-Object IP,EnclosureName,StatusMessage,OnboardAdministrator,PowerSubsystem,CoolingSubsystem