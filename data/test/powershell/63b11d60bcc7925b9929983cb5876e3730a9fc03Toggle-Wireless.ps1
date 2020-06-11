<#
    .SYNOPSIS
        This script will toggle the wireless adapter on or off based on batterystatus
    .DESCRIPTION
        This script will query Win32_Battery and will evaluate the value of the 
        BatteryStatus property to determine what to do. There are 11 possible values
        a value of 2 states the system has access to AC, so I use this as the
        value to check.
        
        If BatteryStatus is 2, the script will disable the wireless adapter that has
        the matching ConnectionID. Any other value then the script will enable the
        same wireless adapter.
        
        For a complete list of values please see the related links section.
    .PARAMETER ConnectionID
        This is a string that represents how the network card is named when you view
        it from the Network and Sharing applet in Windows. This is stored as the
        NetConnectionID in WMI.
        
        This value must match how the network card is displayed otherwise the script
        will fail. For information on changing the name of your network adapter
        please see the related links section.
    .EXAMPLE
        .\Toggle-Wireless.ps1 -ConnectionID 'Wifi'
        
        Description
        -----------
        This example shows the basic syntax of the command. If there is an adapter
        with a NetConnectionID of Wifi, then based on the value of BatteryStatus
        the adapter will either be enabled or disabled.
    .NOTES
        ScriptName : Toggle-Wireless.ps1
        Created By : jspatton
        Date Coded : 06/27/2012 08:54:56
        ScriptName is used to register events for this script
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information
        
        This script needs to run from an administrative shell. 
    .LINK
        https://code.google.com/p/mod-posh/wiki/Production/Toggle-Wireless.ps1
    .LINK
        http://msdn.microsoft.com/en-us/library/windows/desktop/aa394074(v=vs.85).aspx
    .LINK
        http://technet.microsoft.com/en-us/library/dd163571
#>
[CmdletBinding()]
Param
    (
    [string]$ConnectionID = 'Wireless'
    )
Begin
    {
        $ScriptName = $MyInvocation.MyCommand.ToString()
        $ScriptPath = $MyInvocation.MyCommand.Path
        $Username = $env:USERDOMAIN + "\" + $env:USERNAME
 
        New-EventLog -Source $ScriptName -LogName 'Windows Powershell' -ErrorAction SilentlyContinue
 
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nStarted: " + (Get-Date).toString()
        Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
 
        #	Dotsource in the functions you need.
        $Wifi = Get-WmiObject -Class Win32_NetworkAdapter -Filter "NetConnectionID = '$($ConnectionID)'"
        $Battery = Get-WmiObject -Class Win32_Battery -Property BatteryStatus
        $CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = new-object System.Security.principal.windowsprincipal($CurrentUser)
        }
Process
    {
        if (!$wifi)
        {
            $Message = "Unable to find a wireless adapter named $($ConnectionID)"
            Write-Error $Message
            Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
            }
        else
        {
            if (!$principal.IsInRole("Administrators")) 
            {
                $Message = 'You need to run this from an elevated prompt'
                Write-Error $Message
                Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                }
            else
            {
                if($Battery.BatteryStatus -eq 2)
                {
                    $Message = "The system has access to AC so no battery is being discharged. However, the battery is not necessarily charging."
                    Write-Verbose $Message
                    Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
                    $Return = $Wifi.Disable()
                    if ($Return.ReturnValue -ne 0)
                    {
                        $Message = "Unable to disable wireless, the adapter returned: $($Return.ReturnValue)"
                        Write-Verbose $Message
                        Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                        }
                    }
                else
                {
                    $Return = $Wifi.Enable()
                    if ($Return.ReturnValue -ne 0)
                    {
                        $Message = "Unable to enable wireless, the adapter returned: $($Return.ReturnValue)"
                        Write-Verbose $Message
                        Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                        }
                    }
                }
            }
        }
End
    {
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
        }