#Requires -Version 3.0

# # -- Session Variable cmdlets -- # #

function Get-PSSumoLogicApiWebSession
{
    [CmdletBinding()]
    param
    (
        [parameter(
            position = 0,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-PSSumoLogicApiCredential),

        [parameter(
            position = 1,
            mandatory = 0)]
        [switch]
        $PassThru
    )

    begin
    {
        $ErrorActionPreference = $PSSumoLogicApi.errorPreference
    }

    process
    {
        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, $PSSumoLogicAPI.uri.collector)).uri
        Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential -SessionVariable SessionVariable > $null
        $PSSumoLogicAPI.WebSession = $SessionVariable

        if ($PSBoundParameters.ContainsKey("PassThru"))
        {
            $SessionVariable
        }
    }
}