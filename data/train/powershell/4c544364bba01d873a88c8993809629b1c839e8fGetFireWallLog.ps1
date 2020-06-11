#################################################################################
# GetFireWallLog.ps1
# ed wilson, msft, 7/23/2007
#
# uses netsh to show firewall logging configuration
# uses switch with regex parameter to find the line containing the location
# uses [regex] and the split static method to split the line at the = sign this
# produces an array. We use the second element of the array [1] and convert to 
# a string by using the tostring() method from the system.string class
# once we have a string, we can use the trimstart() method to trim leading space
# finally, we use get-content cmdlet to retrieve the contents of the log file
#
#################################################################################

$logFile = netsh firewall show logging
$pattern = '='
switch -regex ($logfile)
{
 "file location" { $file = $switch.current }
}

$matches = [regex]::split($file, $pattern)
$logFilePath = $matches[1].tostring()
$logFilePath+=$logFilePath.trimstart()
Get-Content $logFilePath