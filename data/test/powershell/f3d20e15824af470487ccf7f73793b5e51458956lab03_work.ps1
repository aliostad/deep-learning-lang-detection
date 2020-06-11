# Task 1:
get-command *out*
# Task 2:
man *convert*
# Task 2 answer:
ConvertTo-Html
# Task 3 answer: (found by running 'man *out*')
out-file
out-printer
# Task 4:
get-command *process* -CommandType Cmdlet
# Task 4 answer: TEN
# Task 5:
get-command -verb write -noun *log*
Write-EventLog
# Task 6:
get-command *alias*
Export-Alias
Get-Alias
Import-Alias
New-Alias
Set-Alias
# task 7:
get-command *transcript*
man Start-Transcript
# Task 8:
man get-eventlog -ShowWindow
Get-EventLog -LogName Application -newest 100
# Task 9:
get-service -computername alexandria
get-service -ComputerName atxbs-dc01
# Task 10:
Get-Process -ComputerName atxbs-dc01
# Task 11:
help out-file -ShowWindow
out-file -width <int32>
#Task 12:
out-file -NoClobber
#Task 13:
get-alias
# Task 14:
Get-Process -c atxbs-dc01
# Task 15:
get-command -noun object
# there are nine (9) of 'em
# Task 16:
help about_Arrays





