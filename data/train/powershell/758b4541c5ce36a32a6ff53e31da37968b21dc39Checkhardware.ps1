#Function to check Hardware information from a host
Function checkhardware([string] $Hostname )
{
$computer=get-wmiobject -class win32_computersystem -computername $hostname -errorvariable errorvar
$errorvar.size
if (-not $errorvar)
{
$message="Host="+$Hostname
write-host $message -background "GREEN" -foreground "BLACk"
$message="Description=" +$computer.Description
write-host $message -background "GREEN" -foreground "BLACk"
$message="NumberOfLogicalProcessors="+ 
  $computer.NumberOfLogicalProcessors
write-host $message -background "GREEN" -foreground "BLACk"
$message="NumberOfProcessors="+ $computer.NumberOfProcessors
write-host $message -background "GREEN" -foreground "BLACk"
$message="TotalPhysicalMemory=" +$computer.TotalPhysicalMemory
write-host $message -background "GREEN" -foreground "BLACk"
$message="Model=" +$computer.Model
write-host $message -background "GREEN" -foreground "BLACk"
$message="Manufacturer=" +$computer.Manufacturer
write-host $message -background "GREEN" -foreground "BLACk"
$message="PartOfDomain="+ $computer.PartOfDomain
write-host $message -background "GREEN" -foreground "BLACk"
$message="CurrentTimeZone=" +$computer.CurrentTimeZone
write-host $message -background "GREEN" -foreground "BLACk"
$message="DaylightInEffect="+$computer.DaylightInEffect
write-host $message -background "GREEN" -foreground "BLACk"
}
} 
