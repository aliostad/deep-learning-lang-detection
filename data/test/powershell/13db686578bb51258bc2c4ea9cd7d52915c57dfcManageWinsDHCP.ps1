#--------------------------------------------------------------------
# ManageWinsDHCP.ps1
# ed wilson, msft, 9/22/2007
# Manages wins and dhcp servers
# uses param statement, switch statement, and netsh
#
#---------------------------------------------------------------------
param($computer, $ip, $action, [switch]$help)

function funHelp()
{
$helpText=@"
DESCRIPTION:
NAME: ManageWinsDHCP.ps1
Manages DHCP and WINS servers on a local or remote machine

PARAMETERS: 
-computer Specifies the name of the server to run the script
-ip       IP address of the server to run the script
-action   Specifies action to perform < shoWins, shoDHCP, 
          shoAllDHCP, addDHCP, deleteDHCP >
-help     prints help file

SYNTAX:
ManageWinsDHCP.ps1 

Displays message an action must be specified, and lists help 

ManageWinsDHCP.ps1 -computer MunichServer -action shoWins

Lists Wins Server configuration on a remote server
named MunichServer

ManageWinsDHCP.ps1 -computer MunichServer -action shoDHCP

Lists DHCP Server configuration on a remote server
named MunichServer

ManageWinsDHCP.ps1 -action shoAllDHCP

Lists all authorized DHCP servers from Active Directory

ManageWinsDHCP.ps1 -action addDHCP -computer berlin -ip 192.168.1.1

Adds a DHCP server named berlin with ip address of 192.168.1.1 to be
authorized in Active Directory

ManageWinsDHCP.ps1 -action deleteDHCP -computer berlin -ip 192.168.1.1

Removes a previously authorized DHCP server named berlin with ip address 
of 192.168.1.1 from Active Directory

ManageWinsDHCP.ps1 -help

Prints the help topic for the script

"@
 $helpText
 exit
}


if($help)       { "Printing help now..." ; funHelp }
if(!$action)    { Write-Error "An action must be specified ..." ; funHelp }
if(!$computer)  { Write-Warning "Using default server..." }


switch($action)
{
 "shoWins"    { netsh wins dump $computer }
 "shoDHCP"    { netsh dhcp show server $computer }
 "shoAllDHCP" { netsh dhcp show server }
 "addDHCP"    { 
               if(!$computer -or !$ip) 
			     { "Both the computer name " +
			        "and the IP address must be specified ..." ; 
				    funHelp 
				 }
               netsh dhcp add server $computer $ip 
			  }
 "deleteDHCP" { 
               if(!$computer -or !$ip) 
			     { "Both the computer name " +
			        "and the IP address must be specified ..." ; 
				    funHelp 
				 }
               netsh dhcp delete server $computer $ip
			  }
 }