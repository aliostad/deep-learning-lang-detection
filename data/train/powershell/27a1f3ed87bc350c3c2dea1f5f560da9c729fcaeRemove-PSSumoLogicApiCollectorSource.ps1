#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Remove-PSSumoLogicApiCollectorSource
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
        [ValidateNotNullOrEmpty()]
        [int[]]
        $CollectorId,

        # Inpurt SourceId
        [parameter(
            position = 1,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
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
            if ($PSBoundParameters.ContainsKey("Async"))
            {
                Write-Verbose "Running Async execution"
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
                        Uri         = $uri.AbsoluteUri
                        Method      = "Delete"
                        ContentType = $PSSumoLogicApi.contentType
                        WebSession  = $WebSession
                        TimeoutSec  = $timeoutSec
                    }
                    Write-Verbose -Message ("Posting Asynchronous Delete Source for Collector Request '{0}'" -f $uri)
                    Invoke-RestMethod @param
                }

                $asyncParam = @{
                    Command     = $command
                    CollectorId = $CollectorId
                    SourceId    = $Id
                    WebSession  = $WebSession
                    timeoutSec  = $timeoutSec
                }
                Invoke-PSSumoLogicApiInvokeCollectorSourceAsync @asyncParam
            }
            else # not Async Invokation
            {
                foreach ($Collector in $CollectorId)
                {
                    foreach ($Source in $Id)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Delete"
                            ContentType = $PSSumoLogicApi.contentType
                            WebSession  = $WebSession
                            TimeoutSec  = $timeoutSec
                        }
                        Write-Verbose -Message ("Posting Synchronous Delete Source for Collector Request '{0}'" -f $uri)
                        (Invoke-RestMethod @param).source
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
