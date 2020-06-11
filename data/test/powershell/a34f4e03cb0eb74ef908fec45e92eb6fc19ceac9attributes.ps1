<#
    Contains methods for working with custom attributes.

    https://app.teamdynamix.com/TDWebApi/Home/section/Attributes
#>

#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscCustomAttribute
{
    <#
    .SYNOPSIS
        Gets the custom attributes for the specified component.
    .DESCRIPTION
        Use Get-TdpscCustomAttribute to view all custom attributes for the specified component.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER ComponentId
        The component ID.
    .PARAMETER AssociatedTypeId
        The associated type ID to get attributes for. For instance, a ticket type ID might be provided here.
    .PARAMETER AppId
        The associated application ID to get attributes for.
    .EXAMPLE
        Get-TdpscCustomAttribute -ComponentId 63

        Returns all custom attributes for the specified component.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.CustomAttributes.CustomAttribute or System.Object[].
        Get-TdpscCustomAttribute returns a System.Object[] object if multiple attributes are returned. If a single attribute is found, Get-TdpscCustomAttribute returns a PSObject or TeamDynamix.Api.CustomAttributes.CustomAttribute object. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Attributes#GETapi/attributes/custom?componentId={componentId}&associatedTypeId={associatedTypeId}&appId={appId}
    #>

    [CmdletBinding()]
    [OutputType([PSObject], [TeamDynamix.Api.CustomAttributes.CustomAttribute[]], [System.Object[]])]
    Param
    (
		[String]$Bearer,

        [Parameter(Mandatory=$true)]
		[Int32]$ComponentId,

		[Int32]$AssociatedTypeId = 0,

		[Int32]$AppId = 0
    )

    Begin
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] start"
        Write-Debug -Message "ParameterSetName = $($PSCmdlet.ParameterSetName)"
        Write-Debug -Message "Called from $($stack = Get-PSCallStack; $stack[1].Command) at $($stack[1].Location)"
    }
    Process
    {
        Write-Debug -Message 'Process being called'

        if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

        $queryParms = @{
            componentId      = $ComponentId
            associatedTypeId = $AssociatedTypeId
            appId            = $AppId
        }

        $query = ($queryParms.GetEnumerator() | Where-Object {
                [string]::IsNullOrEmpty($_.Value) -eq $false
            } | ForEach-Object {
                $_.Key + '=' + [System.Uri]::EscapeDataString($_.Value)
            }) -join '&'

        $parms = @{
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Get'
            Uri             = (Get-TdpscApiBaseAddress) + 'attributes/custom{0}' -f ("?$query", '')[[string]::IsNullOrEmpty($query)]
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.CustomAttributes.CustomAttribute[]
        }
        else
        {
            $request.Content | ConvertFrom-Json
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

Export-ModuleMember -Function Get-TdpscCustomAttribute
