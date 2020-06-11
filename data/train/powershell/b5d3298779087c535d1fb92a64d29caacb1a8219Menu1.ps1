function show-Menu
{
	param (
		[string]$Title = 'My Menu'
	)
	cls
	Write-Host " "
	Write-Host -ForegroundColor Cyan "============= $Hamid AD_Menu POWERSHELL =============="
        Write-Host " "
	Write-Host -ForegroundColor Green "   # Press '1' for Show all AD-user name."
	Write-Host " "	
	Write-Host -ForegroundColor Green "   # Press '2' for Reset password."
	Write-Host " "
	Write-Host -ForegroundColor Green "   # Press '3' for Disable user account."
	Write-Host " "
	Write-Host -ForegroundColor Green "   # Press '4' for Enable user account."
	Write-Host " "
	Write-Host -ForegroundColor Green "   # Press '5' for Unlock user account."
	Write-Host " "
	Write-Host -ForegroundColor Green "   # Press '6' for Delete user account."
	Write-Host " "
	Write-Host -ForegroundColor Green "   # Press 'Q' for to quit."
	Write-Host " "
}
do
{
    Show-Menu –Title "BIG MENU"
    $input = Read-Host "Please make a selection"
    Import-Module ActiveDirectory
    switch ($input)
     {
           '1' {
                cls
                'You chose option #1 to show name of all AD_User.'
		 Get-ADUser -filter * | ft Name 
           } '2' {
                cls
                'You chose option #2 to Reset password of AD_User.'
		$user=Read-Host "Enter AD_Username"
                $newpw=Read-Host "Enter the new password" -AsSecureString
                Set-ADAccountPassword $user -NewPassword $newpw | Set-ADuser -ChangePasswordAtLogon $True
           } '3' {
                cls
                'You chose option #3 to Disable AD_User account.'
                $user=Read-Host "Enter AD username"
                Disable-ADAccount $user
           } '4' {
                cls
                'You chose option #4 to Enable AD_User account.'
                $user=Read-Host "Enter AD username"
                Enable-ADAccount $user
           } '5' {
                cls
                'You chose option #5 to Unlock AD_User account.'
                $user=Read-Host "Enter AD username"
                Unlock-ADAccount $user
           } '6' {
                cls
                'You chose option #6 to Delete AD_User account.'
                $user=Read-Host "Enter AD username"
                Remove-ADUser $user
	   } 'q' {
                return
           }
     }
     pause
}until ($input -eq 'q')
