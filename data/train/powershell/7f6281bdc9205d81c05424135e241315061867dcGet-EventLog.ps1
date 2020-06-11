#
# Get_EventLog.ps1
#
Get-EventLog -LogName Application -Newest 1

Get-EventLog -LogName Application -Newest 1 |select Message

Get-EventLog -LogName Application -Newest 10 -Message "*Microsoft*" |select Message

Get-EventLog -LogName Application -Newest 10 -Message "*Microsoft*" |select -expandproperty Message

#
# Measure Performance of Event Log Command
#
#Take less than 1 second
Measure-Command -Expression {Get-EventLog -LogName Application}
#Takes about 5 second
Measure-Command -Expression {Get-WinEvent @{logname='application'}}

Measure-Command -Expression {[datetime]::now}

Measure-Command -Expression {get-date}

#Get event log since yesterday to today
Get-EventLog -LogName Application -EntryType Error -After (Get-Date).AddDays(-1).ToShortDateString() -Before (Get-Date).ToShortDateString() |select -expandproperty Message
