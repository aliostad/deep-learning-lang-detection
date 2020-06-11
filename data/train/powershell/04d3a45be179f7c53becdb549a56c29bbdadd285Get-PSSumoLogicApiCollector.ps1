#Requires -Version 3.0

# # -- Collector cmdlets -- # #

function Get-PSSumoLogicApiCollector
{

    [CmdletBinding()]
    param
    (
        # Input CollectorId
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [int[]]
        $Id = $null,

        [parameter(
            position = 1,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession = $PSSumoLogicAPI.WebSession,

        [parameter(
            position = 2,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $timeoutSec = $PSSumoLogicAPI.TimeoutSec,

        [parameter(
            position = 3,
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
            if ($null -eq $Id)
            {
                [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, $PSSumoLogicAPI.uri.collector)).uri
                (Invoke-RestMethod -Uri $uri -Method Get -WebSession $WebSession -TimeoutSec $timeoutSec).collectors
            }
            else
            {
                if ($PSBoundParameters.ContainsKey("Async"))
                {
                    Write-Verbose "Running Async execution"
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
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId -f $Collector))).uri
                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Get"
                            ContentType = $PSSumoLogicApi.contentType
                            WebSession  = $WebSession
                            TimeoutSec  = $timeoutSec
                        }

                        Write-Verbose -Message ("Sending Asynchronous Get Collector Request '{0}'" -f $uri)
                        Invoke-RestMethod @param
                    }

                    $asyncParam = @{
                        Command     = $command
                        CollectorId = $Id
                        WebSession  = $WebSession
                        timeoutSec  = $timeoutSec
                    }
                    Invoke-PSSumoLogicApiInvokeCollectorAsync @asyncParam
                }
                else
                {
                    foreach ($Collector in $Id)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId -f $Collector))).uri

                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Get"
                            ContentType = $PSSumoLogicApi.contentType
                            WebSession  = $WebSession
                            TimeoutSec  = $timeoutSec
                        }

                        Write-Verbose -Message ("Sending Synchronous Get Collector Request '{0}'" -f $uri)
                        (Invoke-RestMethod @param).Collector
                    }
                }
            }
        
        }
        catch [System.Management.Automation.ActionPreferenceStopException]
        {
            switch ($_.Exception)
            {
                [System.Net.WebException] {throw $_.Exception}
                default                   {throw $_}
            }
        }
    }
}