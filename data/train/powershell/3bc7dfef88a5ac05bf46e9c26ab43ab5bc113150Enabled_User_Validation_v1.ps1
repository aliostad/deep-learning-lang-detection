# This is a bulk Enabled User Validation script written by Rob Sanderson.
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
$ListFilePath = "C:\WindowsPowerShell\Modules\SIDHistory\SIDHistory\"
$SaveFilePath = "C:\WindowsPowerShell\Modules\SIDHistory\SIDHistory\"
$FileName = "Migrated_User__Status_$date.txt"
$FileName2 = "Migrated_User__Status_$date.csv"
$ImportFile = "migrated_users_20140429.txt"
$outarray = @()


#Obtains information on Migrated Users to determine if Enabled.

$accounts = Get-Content $ListFilePath$ImportFile

foreach ($account in $accounts){
# This script will dump the users from the list that are not enabled.
dsquery user -samid $account -limit 0 | dsget user -samid -disabled -fn -ln | Find /V "dsget succeeded"| Find /V "  samid" | Out-File $SaveFilePath$FileName -Append
    $outstring=$user.trim(" ") -replace('\s+',',')
    $outarray +=$outstring
}

$outarray | ConvertFrom-Csv -Delimiter ',' -Header "samid","fn","ln","disabled" | Export-CSV $SaveFilePath$FileName2 -NoTypeInformation

# "End of Run $datetime" | Out-File $SaveFilePath$FileName -Append

