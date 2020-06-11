#Function to check the OS information on the host machine
Function checkOS([string] $Hostname)
{
${LocationCSV} = ${NodeLocation} +"\CheckOS_${Hostname}.CSV"
${LocationXML} = ${NodeLocation} +"\CheckOS_${Hostname}.XML"
$os=get-wmiobject -class win32_operatingsystem -computername $hostname -errorvariable errorvar

if (-not $errorvar)
{
$os|export-csv -noTypeInformation -path ("${LocationCSV}")

#($os | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

<#
$message= "OSArchitecture="+$os.OSArchitecture
write-host $message -background "GREEN" -foreground "BLACk"
$message= "OSLanguage="+$os.OSLanguage
write-host $message -background "GREEN" -foreground "BLACk"
$message= "OSProductSuite="+$os.OSProductSuite
write-host $message -background "GREEN" -foreground "BLACk"
$message= "OSType="+$os.OSType
write-host $message -background "GREEN" -foreground "BLACk"
$message= "BuildNumber="+$os.BuildNumber
write-host $message -background "GREEN" -foreground "BLACk"
$message= "BuildType="+$os.BuildType
write-host $message -background "GREEN" -foreground "BLACk"
$message= "Version="+$os.Version
write-host $message -background "GREEN" -foreground "BLACk"
$message= "WindowsDirectory="+$os.WindowsDirectory
write-host $message -background "GREEN" -foreground "BLACk"
$message= "PlusVersionNumber="+$os.PlusVersionNumber
write-host $message -background "GREEN" -foreground "BLACk"
$message= "FreePhysicalMemory="+$os.FreePhysicalMemory
write-host $message -background "GREEN" -foreground "BLACk"
$message= "FreeSpaceInPagingFiles="+$os.FreeSpaceInPagingFiles
write-host $message -background "GREEN" -foreground "BLACk"
$message= "FreeVirtualMemory="+$os.FreeVirtualMemory
write-host $message -background "GREEN" -foreground "BLACk"
$message= "PAEEnabled="+$os.PAEEnabled
write-host $message -background "GREEN" -foreground "BLACk"
$message= "ServicePackMajorVersion=" +$os.ServicePackMinorVersion
write-host $message -background "GREEN" -foreground "BLACk"
$message= "ServicePackMinorVersion=" +$os.ServicePackMinorVersion
write-host $message -background "GREEN" -foreground "BLACk"
#>
}

}
#Function to check the Processor information on the host machine
Function checkProcessor([string] $Hostname)

{
${LocationCSV} = ${NodeLocation} +"\CheckProcessor_${Hostname}.CSV"
${LocationXML} = ${NodeLocation} +"\CheckProcessor_${Hostname}.XML"
$processor=get-wmiobject -class win32_Processor -computername $hostname -errorvariable errorvar

if (-not $errorvar)
{
$processor|export-csv -noTypeInformation -path ("${LocationCSV}")

#$processor=get-| ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")


}

}