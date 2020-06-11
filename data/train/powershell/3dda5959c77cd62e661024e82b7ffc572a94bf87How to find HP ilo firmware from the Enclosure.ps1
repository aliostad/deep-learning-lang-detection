#Author : Ganesh Sekarbabu
#Site - https://techbrainblog.com/
#Purpose: To find the HP ilo firmware version of the blades running in HP Enclosure.
# Download the HP CMDLTS from the " http://www8.hp.com/us/en/products/server-software/product-detail.html?oid=5440657#!tab=features "
# By using this HP CMDLTS we can  Configure and manage insight Lights Out (iLO), HP BIOS and Onboard Administrator (OA)
# To run this script pls check the avilabilty of conect-HPOA and Get-HPOAServerList cmdlet
#Reference - http://techbrainblog.com/2016/01/07/powershell-script-to-find-the-ilo-firmware-of-the-blades-running-on-hp-enclosure/
# Provide the Enclosure and ilo IP and the username password of the Enclosure and blades.





$dd = Read-host " Enter the HP OA IP "

$c = Connect-HPOA $dd
$username = Read-Host "Enter the username for ilo"
$passwd = Read-host "Enter the password for the ilo"



Get-HPOAServerList  -Connection $c | Select-Object -ExpandProperty serverlist | FT Bay,iLOName,iLOIPAddress,@{Name=’FIRMWARE Version';Expression={[string]($_.iLOIPAddress | Get-HPiLOFirmwareVersion -Username $username -Password $passwd | 
Select-Object FIRMWARE_VERSION ) }}

 

