<#
.SYNOPSIS
Writes the diagnostic message at the Warn level

.DESCRIPTION
Long description

.PARAMETER Message
The message to be written

.PARAMETER Error
An optional ErrorRecord to be written with the message

.EXAMPLE
Write-LogWarn "Test Message"
Writes a Warn diagnostic message

#>
function Write-LogWarn {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Message,

        [Parameter(Mandatory = $false, Position = 1)]
        [System.Management.Automation.ErrorRecord] $Error
    )

    $params = @{
        Level      = "Warn"
        LoggerName = $(Get-PSCallStack)[1].Command
        Message    = (Format-LogMessage -Message $Message -Error $Error)
    }
    
    Write-LogMessage @params
}