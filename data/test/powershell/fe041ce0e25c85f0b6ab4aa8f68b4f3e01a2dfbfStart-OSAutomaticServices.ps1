<#
.SYNOPSIS
    Function to start all stopped Automatic services on one or more computers.
.DESCRIPTION
    Function to start all stopped Automatic services on one or more computers.
.PARAMETER ComputerName
    In the parameter ComputerName you can specific which computer(s) you want to target.
.PARAMETER CheckAll
    By default some Automatic services which are sometimes stopped are excluded. By using the -CheckAll switch, these services are targeted as well.
.PARAMETER CheckOnly
    By default all Automatic services which are stopped are attempted to be started. By using the -CheckOnly switch, it will just display the stopped Automatic services and will not attempt to start them.
.EXAMPLE
    PS C:\>Start-OSAutomaticServices -ComputerName computer1

    This command will check the status of all Automatic services on computer1 and will attempt to start the ones that are stopped.
.NOTES
    Author   : Ingvald Belmans
    Website  : http://www.supersysadmin.com
    Version  : 1.0 
    Changelog:
        - 1.0 (2015-08-30) Initial version.
.LINK
    http://www.supersysadmin.com 
#>
function Start-OSAutomaticServices
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true, 
            ValueFromPipelineByPropertyName=$true
            )
        ]
        [String[]]
        $ComputerName,
        [switch]
        $CheckAll,
        [switch]
        $CheckOnly
    )
    Begin
    {
    }
    Process
    {
        foreach ($Computer in $ComputerName)
        {
            if ($CheckAll)
            {
                $CheckAutomaticService = Get-WmiObject -Class Win32_Service -ComputerName $Computer | Where-Object -FilterScript {$_.StartMode -eq 'Auto' -and $_.State -ne 'Running'}
            }
            else
            {
                $CheckAutomaticService = Get-WmiObject -Class Win32_Service -ComputerName $Computer | Where-Object -FilterScript {$_.StartMode -eq 'Auto' -and $_.State -ne 'Running' -and $_.Name -ne 'clr_optimization_v4.0.30319_32' -and $_.Name -ne 'clr_optimization_v4.0.30319_64'}
            }
            if ($CheckAutomaticService -eq $null)
            {
                Write-Information -MessageData "`nAll Automatic services are already started, no action was taken." -InformationAction Continue
            }
            else
            {
                Write-Information -MessageData "`nFollowing Automatic services were found stopped:" -InformationAction Continue
                $CheckAutomaticService | Select-Object -Property PSComputerName, Name, DisplayName, State, StartMode
            if ($CheckOnly)                
            {            
                Write-Information -MessageData "`nCheck only, rerun the command without the -CheckOnly switch to start all Automatic services that are stopped." -InformationAction Continue
            }
            else
            {
                Write-Information -MessageData "`nAttempting to start the stopped services:`n" -InformationAction Continue
                foreach ($StoppedService in $CheckAutomaticService)
                {                
                    $StartService = $StoppedService.StartService()
                    $ServiceName = $StoppedService.Name
                    $ServiceDisplayName = $StoppedService.DisplayName
                    switch ($StartService.ReturnValue)
                    {
                        0 { Write-Information -MessageData "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The request was accepted." -InformationAction Continue}
                        1 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The request is not supported."} 
                        2 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The user did not have the necessary access."} 
                        3 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service cannot be stopped because other services that are running are dependent on it."} 
                        4 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The requested control code is not valid, or it is unacceptable to the service."} 
                        5 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The requested control code cannot be sent to the service because the state of the service (Win32_BaseService State property) is equal to 0, 1, or 2."} 
                        6 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service has not been started."} 
                        7 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service did not respond to the start request in a timely fashion."}
                        8 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): Unknown failure when starting the service."}
                        9 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The directory path to the service executable file was not found."}            
                        10 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service is already running."}            
                        11 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The database to add a new service is locked."}            
                        12 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): A dependency this service relies on has been removed from the system."}            
                        13 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service failed to find the service needed from a dependent service."}            
                        14 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service has been disabled from the system."}            
                        15 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service does not have the correct authentication to run on the system."}            
                        16 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): This service is being removed from the system."}            
                        17 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service has no execution thread."}            
                        18 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service has circular dependencies when it starts."}            
                        19 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): A service is running under the same name."} 
                        20 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service name has invalid characters."}                       
                        21 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): Invalid parameters have been passed to the service."}            
                        22 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The account under which this service runs is either invalid or lacks the permissions to run the service."}            
                        23 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service exists in the database of services available from the system."}            
                        24 { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The service is currently paused in the system."}
                        default { Write-Warning -Message "[$Computer] Starting service $ServiceName ($ServiceDisplayName): The result of the StartService command could not be determined."}                   }
                    }
                }
            }
        }
    }
    End
    {
    }
}
