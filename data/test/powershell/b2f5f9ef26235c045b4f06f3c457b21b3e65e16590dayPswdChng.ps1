# Script to retrieve AD Users who have not logged on in the last 90 days.
# Based off of script by Michael Trigg on www.spiceworks.com
# http://community.spiceworks.com/scripts/show/1861-find-and-disable-or-remove-inactive-ad-computer-accounts

# Defines cut off date as 90 days before today
import-module activedirectory

$last90Days = (Get-Date).AddDays(-89)

$saveFile = Read-Host -Prompt "Name to save the file to"

$saveFile = 'C:\Users\chris.smith\Documents\Sec\AD Reports\' + $saveFile

Get-ADUser -Properties SamAccountName,passwordlastset,lastLogonDate -Filter {(passwordlastset -lt $last90Days) -and (enabled -eq 'True')} | 
  Select-Object SamAccountName,passwordlastset,lastLogonDate | 
  Export-CSV $saveFile -NoTypeInformation -Encoding UTF8