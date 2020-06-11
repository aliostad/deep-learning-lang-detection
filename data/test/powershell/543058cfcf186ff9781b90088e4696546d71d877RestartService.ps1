#plink -i D:\temp\joshuatest.ppk root@joshuatest -m restartservice.commands > restartservice.log.txt

#$eventLogMessage = "Hey! This is from the restartservice:     "

#foreach($key in $EventData.keys) {
#    $eventLogMessage = $eventLogMessage + "Key: " + $key + "     Data: " + $EventData[$key] + "     "
#}

#$command = ("service " + $EventData["ServiceName"] + " restart")
#$eventLogMessage = $eventLogMessage + "Command: " + $command

#Set-Content restartservice.commands $command
Set-Content restartservice.commands "Hello Joshua"

#Write-EventLog -LogName Application -EntryType Error -Source dvDataService -EventId 6 -Message $eventLogMessage