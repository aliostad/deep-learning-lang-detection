<#
.SYNOPSIS
This PS will parse a realtime log to only show most interesting results
A typical log is named: 2016-02-02-RealTime.StoreWindowsService-DefaultErrAndWarnings.log

.PARAMETER count
return only this count of first matching records

.PARAMETER onlyShowErrors
if this switch is set, will output only errors for review. The important thing is look at the time of the errors

.EXAMPLE
.\Parse-RealTimeLog -file '2016-02-02-RealTime.StoreWindowsService-DefaultErrAndWarnings.log' > output.txt
Will show interesting messages sent in the log. This is the most common. It will show sent messages and any errors
and output the parsed text to output.txt

.EXAMPLE
.\Parse-RealTimeLog -file '2016-02-02-RealTime.StoreWindowsService-DefaultErrAndWarnings.log' -count 100
Will only show the first 100 records

.EXAMPLE
.\Parse-RealTimeLog -file '2016-02-02-RealTime.StoreWindowsService-DefaultErrAndWarnings.log' -showReceivedMessages
Will show received messages as well as sent messages
#>

[CmdletBinding()]
param($file, $count, [switch] $showReceivedMessages, [switch] $onlyShowErrors)
if (-not (Test-Path -Path $file)) {
    Write-Output "Could not find file $file"
    return
}

if ($onlyShowErrors) {
    #just filter out all the sent healthMon messages 
    $content = gc -Path $file | ? { $_ -like '*Error RealTime.StoreWindowsService.exe*' `
        -or $_ -like '*Information RealTime.StoreWindowsService.exe 0: Warning: An Azure Service Bus transient error*' }
    if ($count) {
        $content = $content | select -First $count
    }
    $content
    return
}

$content = gc $file | ? { `
    ($_ -NotLike '*nice StoreConfiguration*') `
    -and ($_ -NotLike '*Receiver Started*') `
    -and ($_ -NotLike '*has been successfully initialised*') `

}
if (-not ($showReceivedMessages)) {
    $content = $content | ? { `
        ($_ -NotLike '*received message*') `
        -and ($_ -NotLike '*receive loop triggered*') `
        -and ($_ -NotLike '*ReceiveLoop triggered*') `
        -and ($_ -NotLike '*Info: In PosDeliveries received message*') `
        -and ($_ -NotLike '*No results found in PosDispatchDeliveriesReceiver to return*')
    }
}



if ($count) {
    $content | select -First $count
    return
}
$content


