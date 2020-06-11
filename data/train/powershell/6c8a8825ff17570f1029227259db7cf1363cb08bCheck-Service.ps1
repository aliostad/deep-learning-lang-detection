Workflow Check-Service
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][string[]]$Computer,
        [Parameter(Mandatory=$true)][string]$ServiceName,
        [ValidateScript({$_ -gt 0})][int]$ServiceCount = 1
    )
    
    if ($ServiceCount -gt $Computer.Count)
    {
        Write-Warning "Service count is greater than computer count. Service count is now $($Computer.Count)"
        $ServiceCount = $Computer.Count
    }

    $service = Get-WmiObject -Class Win32_Service -Filter "Name = '$ServiceName'" -PSComputerName $Computer

    if ($service.State -notcontains "Running" -or ($service.state -eq "Running").Count -lt $ServiceCount)
    {
        Write-Verbose "Getting stopped services."
        
        $runservice = inlinescript
        {    
            $USING:service | where {$_.state -ne "Running"} | select -First $USING:ServiceCount
        }

        Write-Verbose "Starting Services."
        Start-Service -Name $ServiceName -PSComputerName $runservice.SystemName
    }
    
    elseif (($service.state -eq "Running").Count -gt $ServiceCount)
    {
        Write-Verbose "Too many services running, getting extras."
        
        $runservice = inlinescript
        {    
            $USING:service | where {$_.state -eq "Running"} | select -Skip $USING:ServiceCount
        }

        Write-Verbose "Stopping Services."
        Stop-Service -Name $ServiceName -PSComputerName $runservice.SystemName
    }

    else
    {
        Write-Verbose "$ServiceCount Services running, no work to do."
    }

    <# 
        .Synopsis
        Check and start/stop a single service on a group of computers based on the paramaters provided.

        .Description
        This workflow is designed to provide an easy way to control a grouped service that 
        cannot, or should not be available on all computers at all times for soem reason.

        .Parameter Computer <string[]>
        The computer, or array of computers to manage a service for.
    
        .Parameter ServiceName <string>
        The service name to manage.

        .Parameter ServiceCount <integer>
        The amount of services in the group that the script should aim to have runnnig at the end. This defaults to 1. 
        If a value larger than the total amount of computer is selected, as many will be started as possible.

        .Example
        Check-Service -Computer TEST_PC -ServiceName bits

        .Example
        Check-Service -Computer "TEST_PC", "TEST_PC2" -ServiceName bits

        .Example
        Check-Service -Computer "TEST_PC", "TEST_PC2" -ServiceName bits -ServiceCount 2
    
        .Notes
        Name  : Check-Service.ps1
        Author: David Green
  
        .Link
        http://www.tookitaway.co.uk
        https://github.com/davegreen/miscellaneous.git
    #>
}
