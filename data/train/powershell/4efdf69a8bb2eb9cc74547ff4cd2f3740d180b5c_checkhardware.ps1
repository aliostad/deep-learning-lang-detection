#Function to check Hardware information from a host
Function checkhardware([string] $Hostname )
{


${LocationCSV} = ${Location} +"\CheckHardware.CSV"
${LocationXML} = ${Location} +"\CheckHardware.XML"
${LocationHTML} = ${Location} +"\CheckHardware.HTML"

$computer=get-wmiobject -class win32_computersystem -computername $hostname -errorvariable errorvar
$errorvar.size
if (-not $errorvar)
{
$computer|export-csv -noTypeInformation -path ("${LocationCSV}")

#$computer|export-CliXml -path ("${LocationXML}")

$Header = "<style>"
$Header = $Header + "BODY{background-color:white;}"
$Header = $Header + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Header = $Header + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: white;background-color:#E6CC80}"
$Header = $Header + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: white;background-color:#F5EBCC}"
$Header = $Header + "</style>"


$Title ="Hardware Report"
$Body = "<h1> $Title </h1>"

#Import-csv ("${LocationCSV}") | ConvertTo-HTML -head $Header -Title "Hardware Configuration"| Out-File ${LocationHTML}




Import-CSV ("${LocationCSV}")  | Select name, domain, manufacturer, model, "Processor", "Speed", "Server Ram", "Server Disk Storage"| convertto-html -head $Header -Body $Body -Title $Title |out-file ${LocationHTML} 

Invoke-Expression ${LocationHTML}


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
