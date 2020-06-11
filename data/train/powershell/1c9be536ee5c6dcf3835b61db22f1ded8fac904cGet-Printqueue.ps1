<#
.SYNOPSIS
    This script displays the printers on a given computer
.DESCRIPTION
    This script first has to load system.printing, then it
    gets the printers (queues). NB: The queues are returned
    in a collection, not an array.
.NOTES
    File Name  : Get-PrintQueue.ps1
	Author     : Thomas Lee - tfl@psp.co.uk
	Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
	    http://www.pshscripts.blogspot.com
    MSDN Sample posted at:
	    http://msdn.microsoft.com/en-us/library/ms552937.aspx
.EXAMPLE
.PARAMETER
    [String] $Computer
#>

param ($computer = "\\Cookham8")

# create an object
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Printing")
$PrintServer = new-object system.printing.printserver "$computer"

# Get the print server's queues
$PrintQueues = $PrintServer.GetPrintQueues()
"Print Queues on: $Computer"
"{0,-45}  {1}" -f "Printer Name", "Shared as"
"{0,-45}  {1}" -f "------------", "---------"

foreach ($queue in $printqueues) {
"{0,-45}  {1}" -f $queue.fullname, $queue.sharename
}