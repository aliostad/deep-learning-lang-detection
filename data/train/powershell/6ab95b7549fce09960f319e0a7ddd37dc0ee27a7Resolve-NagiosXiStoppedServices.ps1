<#
.SYNOPSIS
   Execute the Start-StoppedAutomaticService script against all open Automatic Windows Services
   service problems in Nagios XI.

.DESCRIPTION
   Using the Nagios XI API we can get a list of all open service problems. We can filter this list
   of open service problems for Windows automatic services to attempt to resolve the issue. The
   resolution involves running the Start-StoppedAutomaticService script against the server to start 
   any stopped automatic services. Start-StoppedAutomaticService is part of the MrAWindowsServices
   module (Install-Module MrAWindowsServices). 

   

   Open service problems are services in Nagios that are warning, critical, or unknown and that 
   have not been acknowledged on all servers including those that are up and not in a 
   scheduled down time.

   All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
   your environment. See the documentation for Invoke-NagiosXiApi.

.PARAMETER ComputerName
   Filter by specific computer/host names.

.PARAMETER ServiceName
   Filter by specific Nagios service. (i.e. MSSQLSERVER)

.PARAMETER Comment
   Provide a comment for the acknowledgement.
   
.EXAMPLE
   Resolve-NagiosXiStoppedServiceProblems

.EXAMPLE
   Resolve-NagiosXiStoppedServiceProblems -ServiceName 'MSSQLSERVER'

   Checks nagios for any open service problems with the name MSSQLSERVER and then runs 
   Start-StoppedAutomaticService against the computer/host name associated.
#>
#requires -Modules MrAWindowsServices
function Resolve-NagiosXiStoppedServiceProblems {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$NagiosCoreUrl,
        [string]$ComputerName = '*',
        [string]$ServiceName = 'MSSQLSERVER|W3CSVC'
    )

    Begin {}
    Process {
        Write-Verbose 'Getting Nagios XI open service problems.'
        $AllOpenServiceProblems = Get-NagiosXIAllOpenServiceProblems -NagiosXiApiUrl $NagiosXiApiUrl -NagiosXiApiKey $NagiosXiApiKey
        $AllHostProblems = Get-NagiosXIAllHostProblems -NagiosXiApiUrl $NagiosXiApiUrl -NagiosXiApiKey $NagiosXiApiKey
        $OpenServiceProblems = $AllOpenServiceProblems | Where-Object -FilterScript {$AllHostProblems.name -notcontains $_.host_name}
        
        $FilteredServiceProblems = $OpenServiceProblems | Where-Object -FilterScript {$_.host_name -like $ComputerName -and $_.name -match $ServiceName}

        foreach ($FilteredServiceProblem in $FilteredServiceProblems) {
            Write-Verbose -Message "Starting stopped automatic services on $($FilteredServiceProblem.host_name)"
            # We have a problem with permissions here. We will need a way to provide credentials for executing the resolution command.
            # For now we will assume the account running this has permissions.
            Start-StoppedAutomaticService -ComputerName $FilteredServiceProblem.host_name
        }
    }
    End {}
}