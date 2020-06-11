<#
.SYNOPSIS
Write the log message at the desired level

.DESCRIPTION
Write the log message at the desired level

.PARAMETER Level
The error level

.PARAMETER Message
The error message

.PARAMETER LoggerName
The name of the logger the error should be written too

.NOTES
This is a wrapper function of a static .NET call, it is needed to enable unit testing.
#>
function Write-LogMessage {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet("Trace", "Debug", "Info", "Warn", "Error", "Fatal")]
        [string] $Level,

        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Message,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $LoggerName
    )

    $logger = [NLog.LogManager]::GetLogger($LoggerName)
    $logger.$Level($Message)
}