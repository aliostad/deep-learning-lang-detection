<#  
.SYNOPSIS  
    Set Active Directory Users to expire
.DESCRIPTION  
    This script create Log file for work, Load Users from CSV & Modify AD Accounts to expire with defined date.
.NOTES  
    Author		:	Ashley Bickerstaff
    File Name	:	ExpireADAccount.ps1
    Language	:	PowerShell
    Updated		:	26/02/2015
    Version		:	0.1
.LINK  
#>

#Create log file with date stamp
$datestring = (Get-Date).ToString("s").Replace(":","-")
$file = ".\Expired_Users_$datestring.log"
(Get-Date -format g) | Out-File $File
"`n"  | Out-File $File -Append

# Load Active Directory Module & Import CSV File
Import-Module ActiveDirectory
$list=Import-Csv ".\ExpireUsers.csv"

#Sets AD Account to Disabled
foreach ($entry in $list)
{
  $samAccountName = $entry.samAccountName
  Set-ADUser -Identity $samAccountName -AccountExpirationDate "28 February 2015 14:37:26" -passthru | Out-File $file -Append
}
