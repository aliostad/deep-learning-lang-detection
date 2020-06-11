#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Get-PSSumoLogicApiCollectorSource
{
    [CmdletBinding()]
    param(
        # Input CollectorId
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $CollectorId,

        # Input Source Id
        [parameter(
            position = 1,
            mandatory = 0)]
        [int[]]
        $Id = $null,

        [parameter(
            position = 2,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession = $PSSumoLogicAPI.WebSession,

        [parameter(
            position = 3,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $timeoutSec = $PSSumoLogicAPI.TimeoutSec,

        [parameter(
            position = 4,
            mandatory = 0)]
        [switch]
        $Async
    )

    begin
    {
        $ErrorActionPreference = $PSSumoLogicApi.errorPreference
    }

    process
    {
        try
        {
            if ($PSBoundParameters.ContainsKey("Async"))
            {
                Write-Verbose "Running Async execution"
                $asyncParam = @{
                    CollectorId = $CollectorId
                    WebSession  = $WebSession
                    timeoutSec  = $timeoutSec
                }

                if ($null -eq $SourceId)
                {
                    $command = {
                        param
                        (
                            [int]$Collector,
                            [hashtable]$PSSumoLogicApi,
                            [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,
                            [int]$timeoutSec,
                            [string]$verbose
                        )

                        $VerbosePreference = $verbose
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Get"
                            ContentType = $PSSumoLogicApi.contentType
                            WebSession  = $WebSession
                            TimeoutSec  = $timeoutSec
                        }
                        Write-Verbose -Message ("Sending Asynchronous Get Collector Source Request '{0}'" -f $uri)
                        Invoke-RestMethod @param
                    }

                    Invoke-PSSumoLogicApiInvokeCollectorAsync @asyncParam -Command $command
                }
                else
                {
                    $command = {
                        param
                        (
                            [int]$Collector,
                            [int]$Source,
                            [hashtable]$PSSumoLogicApi,
                            [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,
                            [int]$timeoutSec,
                            [string]$verbose
                        )

                        $VerbosePreference = $verbose
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                        $param = @{
                            Uri          = $uri.AbsoluteUri
                            Method       = "Get"
                            ContentType  = $PSSumoLogicApi.contentType
                            WebSession   = $WebSession
                            timeoutSec   = $timeoutSec
                        }
                        Write-Verbose -Message ("Sending Asynchronous Get Collector Source Request '{0}'" -f $uri)
                        Invoke-RestMethod @param -Command $command
                    }

                    Invoke-PSSumoLogicApiInvokeCollectorSourceAsync @asyncParam -Command $command -SourceId $id
                }
            }
            else
            {
                $param = @{
                    Method      = "Get"
                    ContentType = $PSSumoLogicApi.contentType
                    WebSession  = $WebSession
                    TimeoutSec  = $timeoutSec
                }

                foreach ($Collector in $CollectorId)
                {
                    if ($null -eq $Id)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri                        
                        Write-Verbose -Message ("Sending Synchronous Get Collector Source Request '{0}'" -f $uri)
                        (Invoke-RestMethod -Uri $uri.AbsoluteUri @param).sources
                    }
                    else
                    {
                        foreach ($Source in $Id)
                        {
                            [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                            Write-Verbose -Message ("Sending Synchronous Get Collector Source Request '{0}'" -f $uri)
                            (Invoke-RestMethod -Uri $uri.AbsoluteUri @param).source
                        }
                    }
                }
            }
        }
        catch
        {
            throw $_
        }
    }
}
