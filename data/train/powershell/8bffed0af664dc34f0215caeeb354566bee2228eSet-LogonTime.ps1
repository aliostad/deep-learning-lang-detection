<#
    .SYNOPSIS
        Log time and username to event log
    .DESCRIPTION
        This script logs the username and time to the Application log
        at logon.
    .EXAMPLE
        .\Set-LogonTime.ps1
    .NOTES
        ScriptName : Set-LogonTime.ps1
        Created By : jspatton
        Date Coded : 12/16/2011 09:42:05
        ScriptName is used to register events for this script
        LogName is used to determine which classic log to write to
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information
    .LINK
        https://trac.engr.ku.edu/powershell/browser/Public/Set-LogonTime.ps1
#>
Param
    (
    )
Begin
    {
        $ScriptName = 'UserTraffic'
        $LogName = "Application"
        $ScriptPath = $MyInvocation.MyCommand.Path
        $Username = $env:USERDOMAIN + "\" + $env:USERNAME
 
        New-EventLog -Source $ScriptName -LogName $LogName -ErrorAction SilentlyContinue
 
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nStarted: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
 
        #	Dotsource in the functions you need.
        }
Process
    {
        $Message = Get-Date
        Write-EventLog -LogName $LogName -Source $ScriptName -EventId "105" -EntryType "Information" -Message $Message
        $Message = $env:USERNAME
        Write-EventLog -LogName $LogName -Source $ScriptName -EventId "106" -EntryType "Information" -Message $Message
        }
 End
    {
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message	
        }