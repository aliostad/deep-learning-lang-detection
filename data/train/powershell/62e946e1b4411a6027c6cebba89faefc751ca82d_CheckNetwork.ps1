#Function to check the Network netadapter information on the host machine
Function CheckNetwork([string] $Hostname )
{

${LocationCSV} = ${NodeLocation} +"\CheckNetworkadapter_${HostName}.CSV"
#${LocationXML} = ${NodeLocation} +"\CheckNetworkadapter_${HostName}.XML"
$netadapter=get-wmiobject -class win32_networkadapter -computername $hostname -errorvariable errorvar
$netadapter =
if (-not $errorvar)
{
$netadapter|export-csv -path ("${LocationCSV}") -NoTypeInformation
#($netadapter | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

}

${LocationCSV} = ${NodeLocation} +"\CheckNetworkadapterSetting_${HostName}.CSV"
#${LocationXML} = ${NodeLocation} +"\CheckNetworkadapterSetting_${HostName}.XML"
$netadapter=get-wmiobject -class Win32_NetworkAdapterSetting -computername $hostname -errorvariable errorvar

if (-not $errorvar)
{
$netadapter|export-csv -path ("${LocationCSV}") -NoTypeInformation
#($netadapter | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")
}

${LocationCSV} = ${NodeLocation} +"\CheckNetworkAdapterconfiguration_${HostName}.CSV"
#${LocationXML} = ${NodeLocation} +"\CheckNetworkAdapterconfiguration_${HostName}.XML"
$netadapter=get-wmiobject -class win32_NetworkAdapterconfiguration -computername $hostname -errorvariable errorvar

if (-not $errorvar)
{
$netadapter|export-csv -path ("${LocationCSV}") -NoTypeInformation
#($netadapter | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")



<#
foreach ($netadapter in $netadapter)
{
write-host "---------------------------------------------------" -background "Blue" -foreground "BLACk"
#$message= "netadapter Enabled="+$netadapter.Enable
#write-host $message -background "GREEN" -foreground "BLACk"
$message= "netadapterType="+$netadapter.netadapterType
write-host $message -background "GREEN" -foreground "BLACk"
$message= "Description="+$netadapter.Description
write-host $message -background "GREEN" -foreground "BLACk"
$message= "Manufacturer="+$netadapter.Manufacturer
write-host $message -background "GREEN" -foreground "BLACk"
$message= "NetworkAddresses="+$netadapter.NetworkAddresses
write-host $message -background "GREEN" -foreground "BLACk"
$message= "PermanentAddress="+$netadapter.PermanentAddress
write-host $message -background "GREEN" -foreground "BLACk"
$message= "Physicalnetadapter="+$netadapter.Physicalnetadapter
write-host $message -background "GREEN" -foreground "BLACk"
$message= "ProductName="+$netadapter.ProductName
write-host $message -background "GREEN" -foreground "BLACk"
$message= "ServiceName="+$netadapter.ServiceName
write-host $message -background "GREEN" -foreground "BLACk"
$message= "StatusInfo="+$netadapter.StatusInfo
write-host $message -background "GREEN" -foreground "BLACk"
$message= "Speed="+$netadapter.Speed
write-host $message -background "GREEN" -foreground "BLACk"
$message= "Status="+$netadapter.Status
write-host $message -background "GREEN" -foreground "BLACk"
}
#>
}
}
