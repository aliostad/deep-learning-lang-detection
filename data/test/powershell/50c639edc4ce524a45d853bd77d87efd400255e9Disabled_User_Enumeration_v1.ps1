# This is a bulk Disabled User Enumeration script written by Rob Sanderson.
# C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe

# Changing directory to where modules are stored.
cd C:\WindowsPowerShell\Modules\SIDHistory\SIDHistory

# Importing modules
Import-module ActiveDirectory
Import-Module .\SIDHistory.psm1

# Sets the Date/Time Variable to be used for file creation
# @echo off
set mydatetime=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~-11,2%%time:~-8,2%
$date = Get-Date -f "yyyyMMdd"
$datetime = Get-Date -f "yyyyMMdd_hhmm"
# echo $date
# Add-Content $SaveFilePath$FileName '$date'

# Sets the variables Used during the script.
$SaveFilePath = "C:\WindowsPowerShell\Modules\SIDHistory\SIDHistory\"
$FileName = "cmaxcorp_Disabled_Users_$date.txt"
$FileName2 = "Disabled_Users_cmaxcorp_$date.csv"
$FileName3 = "Disabled_Users2_cmaxcorp_$date.csv"
$FileName4 = "Disabled_Users_KMX_$date.csv"
$FileName5 = "Disabled_Users2_KMX_$date.csv"
$outarray = @()
$outarray2 = @()

#Obtains information on Migrated Users to determine if Enabled.

# This script will enumerate all of the disabled users in the Disabled Users OU of cmaxcorp.
# dsquery user "OU=DisabledAcctUsers,OU=UserObjects,OU=Carmax,DC=cmaxcorp,DC=adcmax,DC=carmax,DC=org" -limit 0 | dsget user -samid -disabled -fn -ln -display | Find /V "dsget succeeded"| Find /V "  samid"| Out-File $SaveFilePath$FileName -Append
$userList=dsquery user "OU=DisabledAcctUsers,OU=UserObjects,OU=Carmax,DC=cmaxcorp,DC=adcmax,DC=carmax,DC=org" -limit 0 | dsget user -samid -disabled -fn -ln | Find /V "dsget succeeded"| Find /V "  samid"
foreach ($user in $userList) {
    $outstring=$user.trim(" ") -replace('\s+',',')
    # $outstring -replace '"',""
    $outarray +=$outstring
    # write-host  `"$outstring`"
}
 $outarray | ConvertFrom-Csv -Delimiter ',' -Header "samid","fn","ln","disabled" | Export-CSV $SaveFilePath$FileName2 -NoTypeInformation
# gc $SaveFilePath$FileName2 | % {$_ -replace '"', ""} | out-file $SaveFilePath$FileName3 -Fo -En ascii
# write-host "This is it!!!"
# write-host $outarray
# $outstring | Export-CSV $SaveFilePath$FileName2 -NoTypeInformation

#--------------------------------------Separates the cmaxcorp and KMX versions of this script----------------------------------------

# This script will enumerate all of the disabled users in the Disabled Users OU of KMX.
# dsquery user "OU=DisabledUsers,OU=CarMaxUsers,OU=Carmax,DC=KMX,DC=LOCAL" -limit 0 | dsget user -samid -disabled -fn -ln -display | Find /V "dsget succeeded"| Find /V "  samid"| Out-File $SaveFilePath$FileName -Append
$user2List=dsquery user "OU=DisabledUsers,OU=CarMaxUsers,DC=KMX,DC=LOCAL" -limit 0 | dsget user -samid -disabled -fn -ln | Find /V "dsget succeeded"| Find /V "  samid"
foreach ($user2 in $user2List) {
    $outstring2=$user2.trim(" ") -replace('\s+',',')
    # $outstring2 -replace '"',""
    $outarray2 +=$outstring2
    # write-host  `"$outstring2`"
}
 $outarray2 | ConvertFrom-Csv -Delimiter ',' -Header "samid","fn","ln","disabled" | Export-CSV $SaveFilePath$FileName4 -NoTypeInformation
# gc $SaveFilePath$FileName4 | % {$_ -replace '"', ""} | out-file $SaveFilePath$FileName5 -Fo -En ascii
# write-host "This is it!!!"
# write-host $outarray2
# $outstring2 | Export-CSV $SaveFilePath$FileName4 -NoTypeInformation