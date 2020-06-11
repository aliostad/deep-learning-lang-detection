#################################################################################
# ConfigureFWLogging.ps1
# ed wilson, msft, 7/23/2007
#
# uses netsh to make changes to firewall logging configuration
# uses named arguments to simplify
# uses funhelp function to display help information
# uses a here string to store the help message
# uses switch statement to process the commandline arguments
#
# This script requires admin rights to make changes to logging
#
#################################################################################
param($action="show",$path,$size,$help)
function funHelp()
{
$helpText=@"
DESCRIPTION:
NAME: ConfigureFWLogging.ps1
Produces a listing of firewall logging settings. Allows config also

PARAMETERS: 
-action Specifies action to perform when the script is run
-help   prints help file

SYNTAX:
ConfigureFWLogging.ps1 
Lists all the firewall logging settings

ConfigureFWLogging.ps1 -action EnableDropped
Configures firewall to log dropped packets

ConfigureFWLogging.ps1 -action EnableConnect
Configures firewall to log connections

ConfigureFWLogging.ps1 -action show
Lists all the firewall logging settings

ConfigureFWLogging.ps1 -action setLogFolder -path "c:\fso\pfirewall.log"
Configures firewall to log to the c:\fso\pfirewall.log file

ConfigureFWLogging.ps1 -action SetLogSize -size 4096"
Configures firewall to a maximum size of 4096 kilobytes


ConfigureFWLogging.ps1 -help ?
Displays the help topic for the script

"@
$helpText
exit
}

if($help) { "Printing help now..." ; funHelp }

if($action)
{ 
 switch($action)
{
 "Show" {  netsh firewall show logging }
 "SetLogFolder"   { netsh firewall set logging filelocation $path }
 "SetLogSize" { netsh firewall set logging maxfilesize = $size } 
 "EnableDropped"  { netsh firewall set logging droppedpackets = ENABLE }
 "EnableConnect"  { netsh firewall set logging connections = ENABLE }
 "DisableDropped" { netsh firewall set logging droppedpackets = DISABLE }
 "DisableConnect" { netsh firewall set logging connections = DISABLE }
 }
}



