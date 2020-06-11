#Function to check Hardware information from a host
Function checkprocessor([string] $Hostname )
{


${LocationCSV} = ${Location} +"\CheckProcessor.CSV"
${LocationXML} = ${Location} +"\CheckProcessor.XML"

$computer=get-wmiobject -class win32_Processor -computername $hostname -errorvariable errorvar
$errorvar.size
if (-not $errorvar)
{
$computer|export-csv -noTypeInformation -path ("${LocationCSV}")

#$computer|export-CliXml -path ("${LocationXML}")


($computer | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

<#
$message="Host="+$Hostname
write-host $message -background "GREEN" -foreground "BLACk"
$message="Description=" +$computer.Description
write-host $message -background "GREEN" -foreground "BLACk"
$message="NumberOfLogicalProcessors="+ $computer.NumberOfLogicalProcessors
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
#>
}

}
