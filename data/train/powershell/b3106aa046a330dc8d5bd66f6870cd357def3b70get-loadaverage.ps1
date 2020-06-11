#############################################################################
##
##
## Get-LoadAverage
##
## Alistair Young/Arkane Systems 2013
##
#############################################################################

<#

.SYNOPSIS

Returns the load average (over one, five, and fifteen minutes) of the local system.

#>

[CmdletBinding()]
param()

Set-StrictMode -Version 3

$SCRIPT:oneMinute = (get-counter '\Load\One Minute Load Average (x 1000)').CounterSamples.RawValue / 1000.0
$SCRIPT:fiveMinute = (get-counter '\Load\Five Minute Load Average (x 1000)').CounterSamples.RawValue / 1000.0
$SCRIPT:fifteenMinute = (get-counter '\Load\Fifteen Minute Load Average (x 1000)').CounterSamples.RawValue / 1000.0

$oneMinute | Add-Member -MemberType NoteProperty -Name Description -Value "One-minute load average"
$fiveMinute | Add-Member -MemberType NoteProperty -Name Description -Value "Five-minute load average"
$fifteenMinute | Add-Member -MemberType NoteProperty -Name Description -Value "Fifteen-minute load average"

$oneMinute | Add-Member -MemberType NoteProperty -Name Span -Value (New-TimeSpan -Minutes 1)
$fiveMinute | Add-Member -MemberType NoteProperty -Name Span -Value (New-TimeSpan -Minutes 5)
$fifteenMinute | Add-Member -MemberType NoteProperty -Name Span -Value (New-TimeSpan -Minutes 15)

$SCRIPT:loadAvg = ($oneMinute, $fiveMinute, $fifteenMinute)

Write-Verbose "load average: $loadAvg"

Write-Output $loadAvg
