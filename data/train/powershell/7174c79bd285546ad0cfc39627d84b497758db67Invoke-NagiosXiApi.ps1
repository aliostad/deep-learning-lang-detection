<#
.SYNOPSIS
Invoke-NagiosXiApi is a wrapper script for interacting with the Nagios XI
REST API. 

.DESCRIPTION
Invoke-NagiosXiApi is a wrapper script for interacting with the Nagios XI
REST API. With the Nagios XI API you can get a host and service status as 
well as a number of other data. If your Nagios XI account has admin access
you can perform other actions through the API such as configuration management
and reading the Nagios XI system status.

Requirements:
* Nagios XI 5 or higher
* Nagios XI Url
* Nagios XI account with API access
* Nagios XI API key - Each user is generated a unique API key in the Admin,
    Manage Users section of Nagios XI.

.NOTES
Created by: Jason Wasser @wasserja
Modified: 4/11/2017 09:07:56 AM 
Version 0.5

.PARAMETER NagiosXiApiUrl
The Url of the Nagios XI API. Example: https://nagiosxi.domain.com/nagiosxi/api/v1/

.PARAMETER NagiosXiApiKey
Each Nagios XI user is generated a unique API key which can be used with the 
API. Only API keys associated with admin accounts are allowed to perform system and 
configuration actions. Read-only accounts can read object status.

It is recommended that you create a read-only account to pre-populate the NagiosXiApiKey
default value in the MrANagios.psm1 script module.

.PARAMETER Resource
The resource is the specific resource and action to take. See the Nagios XI API
documentation for valid resources.

.PARAMETER Method
The REST method you wish to perform (i.e. GET, POST, DELETE). See Nagios XI API
documentation.

.PARAMETER Query
Use the Query parameter to get specific hosts or services.

.EXAMPLE
Invoke-NagiosXiApi -Resource objects/host

hostlist                                
--------                                
@{recordcount=331; host=System.Object[]}

Return a list of all host objects for Nagios XI in JSON format.

.EXAMPLE
Invoke-NagiosXiApi -Resource objects/servicestatus

servicestatuslist                                 
-----------------                                 
@{recordcount=2389; servicestatus=System.Object[]}

Return a list of all services and their status in JSON format.

.EXAMPLE
Invoke-NagiosXiApi -NagiosXiApiKey 'j2k35j123k5j1k351' -Query 'host_name=SERVER01'

servicestatuslist                                 
-----------------                                 
@{recordcount=10; servicestatus=System.Object[]}

Return the status of the services on host named SERVER01 with a specified API key.

.EXAMPLE

Invoke-NagiosXiApi -Resource objects/servicestatus -Query 'host_name=in:SERVER01,SERVER02'

servicestatuslist                               
-----------------                               
@{recordcount=20; servicestatus=System.Object[]}

Return the status of services on hosts SERVER01 and SERVER02.

.EXAMPLE

Invoke-NagiosXiApi -Resource objects/servicestatus -Query 'host_name=lk:SERVER'

servicestatuslist                                 
-----------------                                 
@{recordcount=2389; servicestatus=System.Object[]}

Return the status of services of hosts with SERVER in the name.
#>
function Invoke-NagiosXiApi {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$Resource = 'objects/host',
        [string]$Method = 'Get',
        [string]$Query
    )

    Begin {
        
        $ValidResources = @(
            'system/applyconfig'
            'system/importconfig'
            'system/status'
            'system/user'
            'config/host'
            'config/service'
            'config/hostgroup'
            'config/servicegroup'
            'objects/hoststatus'
            'objects/servicestatus'
            'objects/logentries'
            'objects/statehistory'
            'objects/comment'
            'objects/downtime'
            'objects/contact'
            'objects/host'
            'objects/service'
            'objects/hostgroup'
            'objects/servicegroup'
            'objects/contactgroup'
            'objects/hostgroupmembers'
            'objects/servicegroupmembers'
            'objects/contactgroupmembers'
            'objects/rrdexport'
            'objects/cpexport'
        )
        
        if ($ValidResources -contains $Resource) {
            Write-Verbose "Valid Resource, continuing."
        }
        else {
            Write-Verbose 'invalid resource'
            return
        } 
    }
    Process {
        Write-Verbose 'Invoking Nagios XI REST API'
        $Uri = $NagiosXiApiUrl + $Resource + '/?apikey=' + $NagiosXiApiKey + '&' + $Query
        Write-Verbose "Uri $Uri"
        Invoke-RestMethod -Method $Method -Uri $Uri
    }
    End {
    }
}