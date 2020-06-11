<#
    .SYNOPSIS
        This script queries AD for a list of computers to reboot
    .DESCRIPTION
        This script queries AD for a list of computers to reboot. 
        For each computer returned from the query the shutdown command is executed
    .PARAMETER ADSPath
        This is the LDAP location in ActiveDirectory to search for computer objects. If this parameter
        is left blank, all computers objects in the ActiveDirectory will be returned.
    .EXAMPLE
        .\Reboot-Computer.ps1 -ADSPath 'OU=Workstations,DC=Company,DC=com' -Verbose
        
        Description
        -----------
        This is the basic syntax of the command.
    .NOTES
        ScriptName : Reboot-Computer.ps1
        Created By : jspatton
        Date Coded : 03/30/2012 09:13:54
        ScriptName is used to register events for this script
        LogName is used to determine which classic log to write to
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information

        Command Line Options
        http://technet.microsoft.com/en-us/library/bb491003.aspx

        The options I'm using are as follows:

        -r Reboots after shutdown.
        -f Forces running applications to close
        -m Specifies the computer that you want to shut down.
        -t Sets the imer for sysmte shutdown in seconds (default 20).
        -c Specifies a message to be displayed in the message are of the 
           System Shutdown window. You can use a maximum of 127 characters.

        In order for this script to work against Windows Vista and later
        the Remote Registry Service needs to be started. It is possible
        to start this service remotely, but if you have WMI connectivity
        issues, that may not work. My best suggestion is to have this 
        service enabled and started via Group or Local policy.

    .LINK
        https://code.google.com/p/mod-posh/wiki/Production/Reboot-Computer.ps1
    .LINK
        http://msdn.microsoft.com/en-us/library/ms681381
#>
[CmdletBinding()]
Param
    (
    [string]$ADSPath = (([ADSI]"").distinguishedName)
    )
Begin
    {
        $ScriptName = $MyInvocation.MyCommand.ToString()
        $LogName = "Application"
        $ScriptPath = $MyInvocation.MyCommand.Path
        $Username = $env:USERDOMAIN + "\" + $env:USERNAME
 
        New-EventLog -Source $ScriptName -LogName $LogName -ErrorAction SilentlyContinue
 
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nStarted: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
 
        #	Dotsource in the functions you need.
        Try
        {
            Import-Module .\includes\ActiveDirectoryManagement.psm1
            }
        Catch
        {
            Write-Warning "Must have the ActiveDirectoryManagement Module available."
            Write-EventLog -LogName $LogName -Source $ScriptName -EventID "101" -EntryType "Error" -Message "ActiveDirectoryManagement Module Not Found"
            Break
            }
        
        Write-Verbose "Collect all computer objects from $($ADSPath)"
        $Workstations = Get-ADObjects -ADSPath $ADSPath
        $Message = "Found $($Workstations.Count) computer objects in $($ADSPath)"
        Write-Verbose $Message
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
        
        $ShutdownMessage = "This computer will reboot within the next 2 minutes for weekly maintenance, please save all work."
        $EmailMessage = "Searching for computers in:`n`t$($ADSPath)`nFound $($Workstations.Count) computers.`n"
        
        $SuccessCount = @()
        $FailCount = @()
        
        $EmailSubject = "Rebooting computers in $($ADSPath)"
        $EmailTo = 'administrator@company.com'
        $EmailFrom = 'svc-acct@company.com'
        $EmailSMTP = 'smtp.company.com'
        }
Process
    {
        $EmailMessage += "Attempting to reboot $($Workstations.Count)"
        foreach ($Workstation in $Workstations)
        {            
            $ShutdownScript = "shutdown -r -f -t 120 -m \\$([string]$Workstation.name) -c `"$($ShutdownMessage)`""
            Write-Verbose $ShutdownScript
            Invoke-Expression -Command $ShutdownScript

            $Message = "Recieved a response from $([string]$Workstation.name)"
            Write-Verbose $Message
            Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
            switch ($LASTEXITCODE)
            {
                0
                {
                    $Message = "ComputerName : $([string]$Workstation.name)`nExitCode     : $LASTEXITCODE`nMessage      : $((& net helpmsg $ExitCode)[1])`n"
                    Write-Verbose $Message
                    Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
                    $ThisCode = New-Object -TypeName PSObject -Property @{
                        ComputerName = [string]$Workstation.name
                        ExitCode = $LASTEXITCODE
                        Message = (& net helpmsg $LASTEXITCODE)[1]
                        }
                    $SuccessCount += $ThisCode
                    $SuccessMessage += "$($Message)`n"
                    }
                default
                {
                    $Message = "ComputerName : $([string]$Workstation.name)`nExitCode     : $LASTEXITCODE`nMessage      : $((& net helpmsg $ExitCode)[1])`n"
                    Write-Verbose $Message
                    Write-EventLog -LogName $LogName -Source $ScriptName -EventID "102" -EntryType "Warning" -Message $Message
                    $ThisCode = New-Object -TypeName PSObject -Property @{
                        ComputerName = [string]$Workstation.name
                        ExitCode = $LASTEXITCODE
                        Message = (& net helpmsg $LASTEXITCODE)[1]
                        }
                    $FailCount += $ThisCode
                    $FailMessage += "$($Message)`n"
                    }
                }
            }
        if ($SuccessCount.Count -eq 1)
        {
            $EmailMessage += "$($SuccessCount.Count) computer was successfully rebooted. "
            }
        else
        {
            $EmailMessage += "$($SuccessCount.Count) computers were successfully rebooted. "
            }
        if ($FailCount.Count -eq 1)
        {
            $EmailMessage += "$($FailCount.Count) was unreachable due to power or network issues.`n"
            }
        else
        {
            $EmailMessage += "$($FailCount.Count) were unreachable due to power or network issues.`n"
            }
        $EmailMessage += "Successful reboots:`n"
        $EmailMessage += $SuccessMessage
        $EmailMessage += "Failed attempts:`n"
        $EmailMessage += $FailMessage
        }
End
    {
        Export-Csv -InputObject $FailCount -Path '.\ExitCodes.csv' -NoTypeInformation
        Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $EmailMessage -SmtpServer $EmailSMTP
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message	
        }