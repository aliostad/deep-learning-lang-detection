function Get-DGSDiskSpace {
<#
.SYNOPSIS
    Get disk size, free space, used space from one or more computers
.DESCRIPTION
    Use WMI to get disk size, free space and used space from one or more computers. Defauls to querying localhost.
.EXAMPLE
    Get-DGSDiskSpace
    Show disk space of drives on local computer
.EXAMPLE
    Get-DGSDiskSpace -ComputerName somecomputer
    Show disk space of drives on somecomputer
.EXAMPLE
    'somecomputer' | Get-DGSDiskSpace
    Show disk space of drives on somecomputer getting name from pipeline
.EXAMPLE
    Get-DGSDiskSpace -ComputerName somecomputer -Credential (Get-Credential mydomain\myusername)
    Show disk space of drives on somecomputer using alternative credentials
#>
    [CmdletBinding()]
    param(
        # Name of computer(s) to query
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        $ComputerName = 'localhost'
        ,
        # Credential object to authenticate with
        [PSCredential]$Credential = $null
        ,
        # Unit to show disk size, free space and used space in
        [ValidateSet('KB','MB','GB','TB')]
        [String]$Unit = 'GB'
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
            
                $LogicalDisk = Get-WmiObject -ComputerName $Computer -Class Win32_LogicalDisk -Filter 'DriveType=3' -Property * @Parameters
                $all_good = $true

            }
            Catch {
            
                Throw
                $all_good = $false

            }

            
            if ($all_good) {

                foreach ($Disk in $LogicalDisk) {
                
                    $Properties = [ordered]@{
                        'ComputerName'   = $Disk.PSComputerName
                        'DeviceID'       = $Disk.DeviceID
                        "Size$Unit"      = ( [Math]::Round( $Disk.Size/$("1$Unit"), 2 ) )
                        "UsedSpac$Unit"  = ( [Math]::Round( ($Disk.Size - $Disk.FreeSpace)/$("1$Unit"), 2 ) )
                        'UsedSpace%'     = ( [Math]::Round( (100/$Disk.Size) * ($Disk.Size - $Disk.FreeSpace), 2) )
                        "FreeSpace$Unit" = ( [Math]::Round( $Disk.FreeSpace/$("1$Unit"), 2 ) )
                        'FreeSpace%'     = ( [Math]::Round( (100/$Disk.Size) * $Disk.FreeSpace, 2) )
                    }
                    
                    New-Object -TypeName PSObject -Property $Properties
                
                }

            }

        }

    }
} #end function Get-DGSDiskSpace
