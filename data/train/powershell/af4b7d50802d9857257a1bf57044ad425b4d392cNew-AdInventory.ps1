<#
    .SYNOPSIS
        Get a list of computers from the ActiveDirectory and use WMI to pull some useful properties out.
    .DESCRIPTION
        This script queries ActiveDirectory for a list of computer objects. For each computer it finds
        it pulls Username, SerialNumber, MacAddress, and IpAddress from WMI. These properties are then
        stored back into the computer object in ActiveDirectory. The following is the mapping of WMI
        properties to ActiveDirectory Object Attributes
            description = Username
            macAddress = MacAddress
            ipHostNumber = IpAddress
            serialNumber = SerialNumber
    .PARAMETER ADSPath
        This is the LDAP location in ActiveDirectory to search for computer objects. If this parameter
        is left blank, all computers objects in the ActiveDirectory will be returned.
    .EXAMPLE
        .\New-AdInventory.ps1
        
        Description
        -----------
        The basic syntax of the command is shown above. Nothing is output to the console during runtime,
        any errors or warnings are stored in the Application Log.
    .EXAMPLE
        .\New-AdInventory.ps1 -ADSPath 'OU=Workstations,DC=Company,DC=com'
        
        Description
        -----------
        This limits the script to processing computer objects that exist solely within the Workstations
        OU.
    .EXAMPLE
        .\New-AdInventory.ps1 -ADSPath 'OU=Workstations,DC=Company,DC=com' -Verbose
        
        Description
        -----------
        This will output everything that is happening to each computer object as the script is ran.
    .NOTES
        ScriptName : New-AdInventory.ps1
        Created By : jspatton
        Date Coded : 03/29/2012 10:21:16
        ScriptName is used to register events for this script
        LogName is used to determine which classic log to write to
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information
        
        The account that is used to run this script should have the ability to modify objects in ActiveDirectory.
        This account should also be able to query WMI on the remote computer.
        
        As errors are encountered they are written to the Application log, in addition they are written to the 
        description property of the computer object.
    .LINK
        https://code.google.com/p/mod-posh/wiki/Production/New-AdInventory.ps1
    .LINK
        https://code.google.com/p/mod-posh/wiki/ActiveDirectoryManagement#Get-ADObjects
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
        
        $WorkstationErrors = @()
        
        Write-Verbose "Collect all computer objects from $($ADSPath)"
        $Workstations = Get-ADObjects -ADSPath $ADSPath
        $Message = "Found $($Workstations.Count) computer objects in $($ADSPath)"
        Write-Verbose $Message
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
        }
Process
    {
        foreach ($Workstation in $Workstations)
        {
            Write-Verbose "Ping $([string]$Workstation.name)"
            if ((Test-Connection -ComputerName ([string]$Workstation.name) -Count 1 -ErrorAction SilentlyContinue))
            {
                $ErrorFlag = $false
                Write-Verbose "$([string]$Workstation.name) responded to ping"
                try
                {
                    Write-Verbose "Getting properties from $([string]$Workstation.name)"
                    $ErrorActionPreference = 'Stop'
                    $ThisWorkstation = New-Object -TypeName PSObject -Property @{
                        UserName = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName ([string]$Workstation.name)).UserName
                        SerialNumber = (Get-WmiObject -Class Win32_Bios -ComputerName ([string]$Workstation.name)).SerialNumber
                        MacAddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName ([string]$Workstation.name) |Where-Object {$_.Ipaddress -like '10.133.*'}).MacAddress
                        IpAddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName ([string]$Workstation.name) |Where-Object {$_.Ipaddress -like '10.133.*'}).IpAddress
                        }
                    Write-Verbose $ThisWorkstation |Format-Table -AutoSize
                    }
                catch
                {
                    $Message = $Error[0].Exception.Message
                    Write-EventLog -LogName $LogName -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                    Write-Verbose $Message
                    $ErrorFlag = $true
                    $ThisWorkstation = New-Object -TypeName PSObject -Property @{
                        UserName = $Message
                        SerialNumber = ''
                        MacAddress = ''
                        IpAddress = ''
                        }
                    $WorkstationErrors += $ThisWorkstation
                    }
                }
            else
            {
                $Message = $Error[0].Exception.Message
                Write-EventLog -LogName $LogName -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                Write-Verbose $Message
                $ErrorFlag = $true
                $ThisWorkstation = New-Object -TypeName PSObject -Property @{
                    UserName = $Message
                    SerialNumber = ''
                    MacAddress = ''
                    IpAddress = ''
                    }
                $WorkstationErrors += $ThisWorkstation
                }

            Write-Verbose "Establishing ADSI connection to $([string]$Workstation.name)"
            Write-Verbose "ErrorFlag = $($ErrorFlag)"
            try
            {
                $ErrorActionPreference = 'Stop'
                $AdWorkstation = [adsi]([string]$Workstation.adspath)
                if ($ErrorFlag -eq $false)
                {
                    $AdWorkstation.macAddress = $ThisWorkstation.MacAddress
                    Write-Verbose "Updating macAddress property"
                    $AdWorkstation.serialNumber = $ThisWorkstation.SerialNumber
                    Write-Verbose "Updating serialNumber property"
                    if ($ThisWorkstation.UserName -eq $null)
                    {
                        $AdWorkstation.description = 'Free'
                        }
                    else
                    {
                        $AdWorkstation.description = $ThisWorkstation.UserName
                        }
                    Write-Verbose "Updating description property"
                    $AdWorkstation.ipHostNumber = $ThisWorkstation.IpAddress
                    Write-Verbose "Updating ipHostNumber property"
                    $AdWorkstation.SetInfo()
                    }
                if ($ErrorFlag -eq $true)
                {
                    $AdWorkstation.description = $ThisWorkstation.UserName
                    $Message = "An error was encountered, view the description property for $($Workstation.name) to see error"
                    Write-Verbose $Message
                    Write-EventLog -LogName $LogName -Source $ScriptName -EventID "102" -EntryType "Warning" -Message $Message
                    $AdWorkstation.SetInfo()
                    }
                
                Write-Verbose "Updating $($Workstation.name) with current values"
                }
            catch
            {
                $Message = $Error[0].Exception.Message
                Write-EventLog -LogName $LogName -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                Write-Verbose $Message
                }
            }
        }
End
    {
        $Message = "A total of $($WorkstationErrors.Count) workstation errors were encountered."
        Write-Verbose $Message
        $Message += "`n`nPlease see the Application log on $(& hostname) for EventID 101 and create a filter for Source that matches $($ScriptName)"
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "102" -EntryType "Warning" -Message $Message	
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName $LogName -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message	
        }