##### CREATES A HEARTBEAT EVENT AT 12 NOON LOCAL TIME THAT SCOM REPORTS BACK WITH ## ADAM FOX
## Script Variables
$Log = "System"
$Source = "SCOM HEARTBEAT"
$Message = "Daily SCOM Heartbeat."
$ID = "41199"
$AlertType = "Information" 
$ComputerName = "."
$RawData = ""
 
##Register the source
New-eventlog -logname $Log -ComputerName $ComputerName -Source $Source -ErrorVariable Err -ErrorAction SilentlyContinue
 
##Write to the system log
Write-eventlog -logname $Log -ComputerName $ComputerName -Source $Source -Message $Message -id $ID -EntryType $AlertType
