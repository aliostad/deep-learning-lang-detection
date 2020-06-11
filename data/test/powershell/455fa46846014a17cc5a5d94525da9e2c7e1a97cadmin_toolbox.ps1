Import-Module activedirectory

Function Show-Menu {

Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter your menu text")]
[ValidateNotNullOrEmpty()]
[string]$Menu,
[Parameter(Position=1)]
[ValidateNotNullOrEmpty()]
[string]$Title="Menu",
[switch]$ClearScreen
)

if ($ClearScreen) {Clear-Host}

#build the menu prompt
$menuPrompt=$title
#add a return
$menuprompt+="`n"
#add an underline
$menuprompt+="-"*$title.Length
$menuprompt+="`n"
#add the menu
$menuPrompt+=$menu

Read-Host -Prompt $menuprompt

} #end function

#define menu 
$menu=@"
1 Create new website.
2 Unlock Account or Update end user password
3 Get password expire date
4 Get server disk space
5 Manage mailbox permissions
6 Change Computer Description
Q Quit

Select a task by number or Q to quit
"@

#Keep looping and running the menu until the user selects Q (or q).
Do {
:mainmenu
	Switch (Show-Menu $menu "My Help Desk Tasks" -clear) {
    "1" { 	#Create new website#
	
## Select environment MENU ##
Write-Host "Choose your environment."
Write-Host "1. Development"
Write-Host "2. Beta"
Write-Host "3. Test"
Write-Host "4. Demo"
Write-Host "5. Prod"
write-host "Q to quit"
Write-Host " "
$a = Read-Host "Select 1-5: "
 
Write-Host " "
 
switch ($a) 
    { 
        1 {
           "** Development Environment **";
           $server = 'server.domain.com';
           break;
          }
        2 {
           "** Beta Environment **";
           $server = 'server.domain.com';
           break;
          }
        3 {
           "**Test environment **";
           $server = 'server.domain.com';
           break;
          }
        4 {
           "** Demo environment **";
           $server = 'server.domain.com';
           break;
          }
        5 {
           "** Prod environment **";
           $server = 'server.domain.com';
           break;
          }
        Q {Write-Host "Goodbye!"
           break mainmenu}

    }

$script = {

Import-Module WebAdministration

#Site name
Write-Host "Site Name"
$sitename = Read-Host "Enter Site Name"

#Port
Write-Host "Port (Recommended 80)"
$port = Read-Host "Enter Port Number"

#Home Directory
Write-Host "Home directory location"
$homedir = Read-Host "Enter Home Directory"

#Host Header
Write-Host "Host Header (URL)"
$hostheader = Read-Host "Enter Host Header"

#AppPool
Write-Host "New AppPool name"
$appPool = Read-Host "Enter AppPool Name"

#Store variables in array since they do not transfer remotely otherwise.
$info = @("$sitename","$port","$homedir","$hostheader","$appPool")

#The actual work
New-WebAppPool $info[4]
Set-ItemProperty iis:\apppools\$appPool managedruntimeversion v4.0
New-WebSite -Name $info[0] -Port $info[1] -PhysicalPath $info[2] -HostHeader $info[3] -ApplicationPool $info[4]
}

#This allows the script to run remotely
Invoke-Command -ComputerName $server -ScriptBlock $script -ErrorAction SilentlyContinue
Write-Host "Site creation completed" -ForegroundColor DarkCyan
sleep -Seconds 5
         } 
			
    "2" {	#Unlock AD account or update AD password#
			Write-Host "Begin user account update"
			write-host "1. Unlock User"
			write-host "2. Change Password"
			$a = read-host "Enter choice "
		switch ($a)
			{
			1	{ 	try 	{$user = Read-Host "Enter User (First Initial Lastname) "; Unlock-ADAccount -identity $user}
					catch	{ if ($? -ne $true) { Write-Host "User Unlock failed" -ForegroundColor Red} write-host "$error" -foregroundcolor Red}
				sleep -seconds 5
		
				}
			2	{$user = Read-Host "Enter User "
				$password = Read-Host -Prompt "Enter new password " 
				Write-Host "Required information supplied. Stand by!"
				Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)
				Write-Host "Password updated" -ForegroundColor Green
				sleep -seconds 3
				}
			}
		break;	
		}

    "3" {	#Get password expire date#
			
$user = Read-Host "Enter username: "
        [datetime]::FromFileTime((Get-ADUser -Identity $user -Properties "msDS-UserPasswordExpiryTimeComputed")."msDS-UserPasswordExpiryTimeComputed")
        sleep -seconds 5
        }   
			
	
    "4" {	#Get server disk space#
##Define Primary Menu##
$diskmenu=@"
1 Enter remote server
2 Enter path to server list
Q to quit
"@

switch (show-menu $diskmenu "Please choose an option") {
    "1" {Get-WmiObject Win32_LogicalDisk -filter "DriveType=3" -computer (read-host "Enter server name ") | Select SystemName,DeviceID,VolumeName,@{Name="Size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}};
        sleep -seconds 7
		break; }
    "2" {$list = read-host "Path to server list: "
		Get-WmiObject Win32_LogicalDisk -filter "DriveType=3" -computer (Get-Content $list) | Select SystemName,DeviceID,VolumeName,@{Name="Size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}} | out-gridview;
        break; }
	"Q" {Write-host "Goodbye" -foregroundcolor green
		Return
		}

}
}		
		    
    "5" {	#Manage mailbox permissions#
   $mailboxmenu=@"
1 Add mailbox permissions
2 Remove mailbox permissions
Q to quit
"@

switch (show-menu $mailboxmenu "Please choose an option") {
    "1" {$usermailbox = Read-Host "Please enter mailbox to be modified (first initial lastname) "
         $adduser = Read-Host "Please enter user granting permissions too "
         Add-MailboxPermission -Identity $usermailbox -User $adduser -AccessRights FullAccess;
		 add-recipientpermission $usermailbox -accessrights sendas -trustee $adduser;
		 set-mailbox -identity $usermailbox -grantsendonbehalfto $adduser;
		 sleep -seconds 2
         break;}
    "2" {$usermailbox = Read-Host "Please enter mailbox to be modified (first initial lastname) "
         $removeuser = Read-Host "Please enter user removing permissions from "
         Remove-MailboxPermission -Identity '$usermailbox' -User '$removeuser' -AccessRights FullAccess -InheritanceType All;
		 remove-recipientpermission $usermailbox -accessrights sendas -trustee $removeuser
		 sleep -seconds 2
         break;}
	"Q" {Write-host "Goodbye" -foregroundcolor green
		 Return}
}}

	"6" { 	#Change computer description#
		$computername = Read-Host "Computer requiring description update:  "
		$description = Read-Host "Updated description:  "
		$OSValues = Get-WmiObject -class Win32_OperatingSystem -computername $computername
		$OSValues.Description = $description
		$OSValues.put()
		Write-Host "Confirming changes"
		$OSValues
		pause
		}
		
	"Q" { Write-Host "Goodbye" -ForegroundColor Green
         Return
         }
    Default {Write-Warning "Invalid Choice. Try again."
              sleep -milliseconds 750}
} 
} While ($True)