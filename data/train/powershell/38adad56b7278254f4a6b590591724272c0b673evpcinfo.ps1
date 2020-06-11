#vpcinfo1.0

#this script is created to gather the info of this PC

$usage = "

#show the info of Desktop
#.\vpcinfo.ps1 -desktop

#show the info of bios
#.\vpcinfo.ps1 -bios

#show the info of system information
#.\vpcinfo.ps1 -sysinfo

#show the info of cpu
#.\vpcinfo.ps1 -cpu

#show the info of hard disk
#.\vpcinfo.ps1 -harddisk

#show the info of time
#.\vpcinfo.ps1 -time
"
if($args.Count -gt 1)
{
$usage
exit
}
if($args.Count -eq 0)
{
$usage
exit
}

try{

if ($args[0] -eq "-desktop")
{
    Get-WmiObject -Class Win32_Desktop -ComputerName . | Select-Object -Property [a-z]*
    exit
}

if($args[0] -eq "-bios")
{

    Get-WmiObject -Class Win32_BIOS | Select-Object *
    exit
}

if($args[0] -eq "-sysinfo"){
    Get-WmiObject -Class Win32_ComputerSystem | Select-Object *
    exit
}

if($args[0] -eq "-cpu")
{
    Get-WmiObject -Class Win32_Processor  | Select-Object *
    exit
}

if($args[0] -eq "-harddisk")
{
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
    exit
}

if($args[0] -eq "-time")
{
    Get-WmiObject -Class Win32_LocalTime | Select-Object [a-z]*
    exit
}

throw "Bad Args"
}
catch {
    $usage
    throw "Fail to Get the info!!!"
}