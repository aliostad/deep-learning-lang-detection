# Author : Ganesh Sekarbabu
# Site - https://techbrainblog.com/
# Purpose:  The Find-HPOA cmdlet lists valid Onboard Administrators in the subnet provided. You must provide the subnet in which the Onboard Administrators have to be searched.
# Download the HP CMDLTS from the " http://www8.hp.com/us/en/products/server-software/product-detail.html?oid=5440657#!tab=features "
# By using this HP CMDLTS we can  Configure and manage insight Lights Out (iLO), HP BIOS and Onboard Administrator (OA)
# To run this script pls check the avilabilty of Find-HPOA cmdlet
# Reference - http://techbrainblog.com/2016/01/04/powershell-script-to-find-the-hp-valid-onboard-administrators-list-in-the-subnet/
# Provide the HP OA IP Range subnet 




$IPRange = Read-host " Enter the IP Range of HPOA ( 10.10.10.1-255) "


Find-HPOA -Range $IPRange -Role All 