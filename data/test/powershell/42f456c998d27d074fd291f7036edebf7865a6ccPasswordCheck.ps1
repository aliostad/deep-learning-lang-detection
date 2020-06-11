<#
Script Name:    PasswordCheck.ps1
Author:         Cory Knox
Email:          github.powershell@knoxy.ca
Version:        0.1
Raison d'etre:  Regularly need to check if a user's password has expired. This provides a GUI for it
Requirements:   RSAT with Active Directory Module installed.
                ShowUI (cloned from: https://github.com/show-ui/ShowUI)
                PowerShell 3 (I think, only tested on PowerShell 5 Windows 7/10)
                Elevation *not* required
                User running script must have permissions to query Active Directory
ToDo:           Include error checking for users that don't exist.
                Check lockout status of account.
                Include option to Unlock account. 
#>
Import-Module ShowUI
#AD Commented out while building and testing on home machine without RSAT
#Import-Module ActiveDirectory

#Variables
$pwdExpiryInDays = 182
New-Grid -Columns auto,* -Rows 4 -Children {
 New-Label -Content "Username:"
 New-TextBox -name "Username" -Column 1
 New-Label -Content "Set:" -Row 1
 New-TextBox -name "pwdLastSet" -Row 1 -Column 1
 New-Label  -Content "Expires:" -Row 2
 New-TextBox -Name "pwdExpires" -Row 2 -Column 1
 New-Label -Row 3
 New-Button -Name "Button" -Content "Check Users Password" -Row 3 -Column 1 -IsDefault -On_Click{
  $user = get-aduser $username.text -properties pwdlastset
  $pwdSet = [datetime]::fromFileTime($user.pwdlastset)
  $pwdExp = $pwdSet.AddDays($pwdExpiryInDays)
  $pwdLastSet.text = $pwdSet
  $pwdExpires.text = $pwdExp
 }
} -On_Loaded { $username.Focus() } -AsJob