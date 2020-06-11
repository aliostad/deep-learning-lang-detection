############################################################################
# WorkWithPrinters.ps1
# ed wilson, msft, 7/4/2007
#
# uses named arguments (parameters) to allow to specify different computer
# uses here string for help text
# uses win32_Printer class to manage print devices 
# uses switch to parse the argument value specified for $action
#
############################################################################

param($strComputer="localhost", $printer, $action="list", $help)

function funHelp()
{
$helpText=@"
DESCRIPTION:
NAME: ListPrinterDrivers.ps1
Allows for the management of printers on a local or remote machine.

PARAMETERS: 
-computerName Specifies the name of the computer upon which to run the script
-help         prints help file
-printer      printer name
-action       <list, setDefault, test, pause, resume, cancel, ?>

SYNTAX:
WorkWithPrinters.ps1 -comptuerName MunichServer -action list
  Lists all the printers on a computer named MunichServer

WorkWithPrinters.ps1 -help ?
  Prints the help topic for the script

WorkWithPrinters.ps1 -computername MunichServer -action setDefault -printer hp
 Sets a printer whose name is like hp to the default printer on the munich server
 (assumes there is only one printer whose names is like hp. You need to specify 
  enough to uniquely identify the printer)

WorkWithPrinters.ps1 -action test -printer hp
 Sends a test page to the printer whose name is like hp on the local server
 (assumes there is only one printer whose names is like hp. You need to specify 
  enough to uniquely identify the printer)

WorkWithPrinters.ps1 -action pause -printer hp
 Pauses the printer whose name is like hp on the local server
 (assumes there is only one printer whose names is like hp. You need to specify 
  enough to uniquely identify the printer)

WorkWithPrinters.ps1 -action resume -printer hp
 Resumes the printer whose name is like hp on the local server
 (assumes there is only one printer whose names is like hp. You need to specify 
  enough to uniquely identify the printer)

WorkWithPrinters.ps1 -action cancel -printer hp
 Cancels all print jobs on the printer whose name is like hp on the local server
 (assumes there is only one printer whose names is like hp. You need to specify 
  enough to uniquely identify the printer)
"@
$helpText
exit
}

function funlist()
{
 $Query = "Select name from $class" 
 Get-WmiObject -query $Query -computername $strcomputer | 
 format-list [a-z]*
 exit
}

function funDefault()
{ "Setting defaults on $printer printer ..."
 $query = "Select name from $class where name like '%$printer%'"
 $default = Get-WmiObject -query $Query -computername $strcomputer
 $default.setDefaultPrinter()
 exit
}

function funTest()
{ "Printing test page on $printer printer ..."
 $query = "Select name from $class where name like '%$printer%'"
 $default = Get-WmiObject -query $Query -computername $strcomputer
 $default.PrintTestPage()
 exit
}

function funPause()
{ "Pausing $printer printer ..."
 $query = "Select name from $class where name like '%$printer%'"
 $default = Get-WmiObject -query $Query -computername $strcomputer
 $default.Pause()
 exit
}

function funResume()
{ "Resuming $printer printer ..."
 $query = "Select name from $class where name like '%$printer%'"
 $default = Get-WmiObject -query $Query -computername $strcomputer
 $default.Resume()
 exit
}

function funCancel()
{ "Canceling all print jobs on $printer printer ..."
 $query = "Select name from $class where name like '%$printer%'"
 $default = Get-WmiObject -query $Query -computername $strcomputer
 $default.CancelAllJobs()
 exit
}

$class = "Win32_Printer"

if($help) { "Printing help now..." ; funHelp }
if($action)
{
 switch($action)
  {
   "list" { funlist }
   "setDefault" { funDefault }
   "Test" { funTest }
   "pause" { funPause }
   "resume" { funResume }
   "cancel" { funCancel }
   "default" { "default behavior. Listing printers.
                for more options try workWithPrinters.ps1 -help ?" ;
				funhelp }
   "?" { "Printing help now..." ; funhelp }
  }
}
