#
#     Calculate Load across 4 Web Servers and raise Event if overloaded
#     
#     Created by Charlton Julius
#     V 1.0: 2014-11-14 - Initial Version
#     V 1.1: 2014-11-17 - Added maxLoadPer, ability to Force Event log write


#Set up Parameter to allow Warning to be forced into the Event Log.

param (
    [switch]$forceWarning = $false,
    [int]$maxLoadPer = 50
 )

cls

#Gather Counter information from all Webservers

Write-Host "Gathering information on WebServerA"
$webAConnNum = (Get-Counter -Counter "\\WebServerA\Web Service(_Total)\Current Connections").CounterSamples.CookedValue

Write-Host "Gathering information on WebServerB"
$webBConnNum = (Get-Counter -Counter "\\WebServerB\Web Service(_Total)\Current Connections").CounterSamples.CookedValue

Write-Host "Gathering information on WebServerC"
$webCConnNum = (Get-Counter -Counter "\\WebServerC\Web Service(_Total)\Current Connections").CounterSamples.CookedValue

Write-Host "Gathering information on WebServerD"
$webDConnNum = (Get-Counter -Counter "\\WebServerD\Web Service(_Total)\Current Connections").CounterSamples.CookedValue

Write-Host "`nCalculating Load"

#Calculate Load as a percentage and a rounded percentage

$connSum = ($webAConnNum + $webBConnNum + $webCConnNum + $webDConnNum)

$webAConPer = ($webAConnNum / $connSum) * 100
$webAConPerRound = "{0:N0}" -f $webAConPer

$webBConPer = ($webBConnNum / $connSum) * 100
$webBConPerRound = "{0:N0}" -f $webBConPer

$webCConPer = ($webCConnNum / $connSum) * 100
$webCConPerRound = "{0:N0}" -f $webCConPer

$webDConPer = ($webDConnNum / $connSum) * 100
$webDConPerRound = "{0:N0}" -f $webDConPer


#Set up Event Log for IIS Connection Watcher if it does not already exist

 if (!(Get-Eventlog -LogName "Application" -Source "IIS Connection Watcher")){
      New-Eventlog -LogName "Application" -Source "IIS Connection Watcher"
 }

 #Check if each Webserver is carrying "too much" load. 
 #If so, writes to the console and creates an entry in the above created Event Log

If ($webAConPer -gt $maxLoadPer)
{
    Write-Host "`nWebServerA is Over Loaded, carrying $webAConPerRound% of the load."
    Write-EventLog -LogName Application -Source "IIS Connection Watcher" -EntryType Warning -EventId 10010 -Message "WebServerA is Over Loaded, carrying $webAConPerRound% of the load."
}

ElseIf ($webBConPer -gt $maxLoadPer)
{
    Write-Host "`nWebServerB is Over Loaded, carrying $webBConPerRound% of the load."
    Write-EventLog -LogName Application -Source "IIS Connection Watcher" -EntryType Warning -EventId 10010 -Message "WebServerB is Over Loaded, carrying $webBConPerRound% of the load."
}

ElseIf ($webCConPer -gt $maxLoadPer)
{
    Write-Host "`nWebServerC is Over Loaded, carrying $webCConPerRound% of the load."
    Write-EventLog -LogName Application -Source "IIS Connection Watcher" -EntryType Warning -EventId 10010 -Message "WebServerC is Over Loaded, carrying $webCConPerRound% of the load."
}

ElseIf ($webDConPer -gt $maxLoadPer)
{
    Write-Host "`nWebServerD is Over Loaded, carrying $webDConPerRound% of the load."
    Write-EventLog -LogName Application -Source "IIS Connection Watcher" -EntryType Warning -EventId 10010 -Message "WebServerD is Over Loaded, carrying $webDConPerRound% of the load."
}

#Otherwise, write to console that everything is fine.
#If the -forceWarning switch is used, will write to the Event Log anyway

Else
{
    Write-Host "`nWebservers are balanced"

    if ($forceWarning) {
        Write-Host "However, the Warning is being forced."
        Write-EventLog -LogName Application -Source "IIS Connection Watcher" -EntryType Warning -EventId 10010 -Message "The Webservers are not being detected as Over Loaded, however the warning is being forced."
        Write-Host "`nEvent Log Entry Created."
    }
}

#Statistics written to console

Write-Host "`nFinal Statistics"
Write-Host "-----------------------------------------------"
Write-Host "Server`t`t`tConnections`t`tPercent of Load"
Write-Host "WebServerA","`t$webAConnNum"," ","`t`t`t$webAConPerRound","%"
Write-Host "WebServerB","`t$webBConnNum"," ","`t`t`t$webBConPerRound","%"
Write-Host "WebServerC","`t$webCConnNum"," ","`t`t`t$webCConPerRound","%"
Write-Host "WebServerD","`t$webDConnNum"," ","`t`t`t$webDConPerRound","%"

#If Percent of Load is 0% the server may be unreachable and is not used in the calculation.
