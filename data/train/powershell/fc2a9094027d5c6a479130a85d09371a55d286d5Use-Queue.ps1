<#
.SYNOPSIS
    Demonstrates the use of the .NET Queue object
.DESCRIPTION
    This script implemented a sample of this objct using
    PowerShell
.NOTES
    File Name  : Use-Queue.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell V2 CTP3
.LINK
    http://www.pshscripts.blogspot.com
.EXAMPLE
    PS c:\foo> .\Use-Queue.ps1
	  $myq object at start:
	  3 entries in the queue as follows:
	  entry 0:  Hello
	  entry 1:  World
	  entry 2:  PowerShell Rocks

    	$myq after addding two items:
	  5 entries in the queue as follows:
	  entry 0:  Hello
	  entry 1:  World
	  entry 2:  PowerShell Rocks
	  entry 3:  Added queue object 1
	  entry 4:  Added queue object 2

	  $myq after removing three items:
	  2 entries in the queue as follows:
	  entry 0:  Added queue object 1
	  entry 1:  Added queue object 2

	  Peeked item $peek  = Added queue object 1
	  $myq after peek:
	  2 entries in the queue as follows:
	  entry 0:  Added queue object 1
	  entry 1:  Added queue object 2
#>

##
#  Start of script
##

# Create new queue object
$myq = new-object system.collections.Queue
$myq.Enqueue("Hello")
$myq.Enqueue("World")
$myq.Enqueue("PowerShell Rocks")

# Show queue
"`$myq object at start:"
$i=0
"{0} entries in the queue as follows:" -f $myq.Count
$myq | % {"entry {0}:  {1}" -f $i++,$_ }
""

#Enqueue two objects
$myq.enqueue("Added queue object 1")
$myq.enqueue("Added queue object 2")

# Show queue
"`$myq after addding two items:"
$i=0
"{0} entries in the queue as follows:" -f $myq.Count
$myq | % {"entry {0}:  {1}" -f $i++,$_ }
""
#now dequeue 3 objects
$dq1=$myq.dequeue()
$dq2=$myq.dequeue()
$dq3=$myq.dequeue()

# Show queue
"`$myq after removing three items:"
$i=0
"{0} entries in the queue as follows:" -f $myq.Count
$myq | % {"entry {0}:  {1}" -f $i++,$_ }
""
#Peek at first item
$peek=$myq.peek()
"Peeked item `$peek  = $peek"

# Show queue after peek
"`$myq after peek:"
$i=0
"{0} entries in the queue as follows:" -f $myq.Count
$myq | % {"entry {0}:  {1}" -f $i++,$_ }
# End of scriptcd