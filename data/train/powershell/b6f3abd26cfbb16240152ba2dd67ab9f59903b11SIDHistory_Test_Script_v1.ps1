# This is a bulk SID History removal script written by Rob Sanderson.
# C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe

# Changing directory to where modules are stored.
cd C:\WindowsPowerShell\Modules\SIDHistory\SIDHistory

# Importing modules
Import-module ActiveDirectory
Import-Module .\SIDHistory.psm1
# Sets the Date/Time Variable to be used for file creation
# @echo off

#sets the date variable
set mydatetime=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~-11,2%%time:~-8,2%
$date = Get-Date -f "yyyyMMdd"
$datetime = Get-Date -f "yyyyMMdd_hhmm"
# echo $date
# Add-Content $SaveFilePath$FileName '$date'

# Sets the variables Used during the script.
$ListFilePath = "C:\WindowsPowerShell\Modules\SIDHistory\SIDHistory"
$SaveFilePath = "C:\WindowsPowerShell\Modules\SIDHistory\SIDHistory\"
$FileName = "TestSIDHistory_$datetime.txt"


#sID history deletion for users

$accounts = Get-Content $ListFilePath\sid-users.txt

foreach ($account in $accounts){

# This script will dump the SID History Information.
 Get-SIDHistory –SamAccountName $account | Watch-Job | Out-File $SaveFilePath$FileName -Append

# This script will remove the SID History
# Get-SIDHistory –SamAccountName $account | Remove-SIDHistory | Out-File $SaveFilePath$FileName -Append
}

"End of Run $datetime" | Out-File $SaveFilePath$FileName -Append
