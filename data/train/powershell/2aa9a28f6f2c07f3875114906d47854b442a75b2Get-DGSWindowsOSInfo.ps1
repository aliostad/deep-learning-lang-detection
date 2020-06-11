function Get-DGSWindowsOSInfo {
<#
.SYNOPSIS
    Get disk size, free space, used space from one or more computers
.DESCRIPTION
    Use WMI to get disk size, free space and used space from one or more computers. Defauls to querying localhost.
.EXAMPLE
    Get-DGSWindowsOSInfo
    Show Windows OS information from local computer
.EXAMPLE
    Get-DGSDiskSpace -ComputerName somecomputer
    Show Windows OS information from somecomputer
.EXAMPLE
    'somecomputer' | Get-DGSDiskSpace
    Show Windows OS information from somecomputer getting name from pipeline
.EXAMPLE
    Get-DGSDiskSpace -ComputerName somecomputer -Credential (Get-Credential mydomain\myusername)
    Show Windows OS information from somecomputer using alternative credentials
#>
    [CmdletBinding()]
    param(
        # Name of computer(s) to query
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        $ComputerName = 'localhost'
        ,
        # Credential object to authenticate with
        [PSCredential]$Credential = $null
    )


    BEGIN {
        $Parameters = @{}
        if ($Credential) {
            $Parameters += @{
                'Credential' = $Credential
            }
        }
    }


    PROCESS {
        
        foreach ($Computer in $ComputerName) {

            Write-Verbose "Connecting to $Computer"

            Try {
            
                $OperatingSystem = Get-WmiObject -ComputerName $Computer -Class Win32_OperatingSystem @Parameters -ErrorAction Stop
                $all_good = $true

            }
            Catch {
            
                Throw
                $all_good = $false

            }
            

            if ($all_good) {
            
                $LocalDateTime  = $OperatingSystem.ConvertToDateTime($OperatingSystem.LocalDateTime)
                $LastBootUpTime = $OperatingSystem.ConvertToDateTime($OperatingSystem.LastBootUpTime)
                $SystemUptime = $LocalDateTime - $LastBootUpTime

                $Properties = [ordered]@{
                    'ComputerName'    = $OperatingSystem.CSName
                    'OperatingSystem' = $OperatingSystem.Caption
                    'Version'         = $OperatingSystem.Version
                    'LocalDateTime'   = $LocalDateTime
                    'LastBootUpTime'  = $LastBootUpTime
                    'SystemUptime'    = ('{0}:{1}:{2}:{3},{4}' -f $SystemUptime.Days,$SystemUptime.Hours.ToString('00'),$SystemUptime.Minutes.ToString('00'),$SystemUptime.Seconds.ToString('00'),$SystemUptime.Milliseconds.ToString('000'))
                }

                New-Object -TypeName PSObject -Property $Properties
            
            }
        }

    }
} #end function Get-DGSWindowsOSInfo
