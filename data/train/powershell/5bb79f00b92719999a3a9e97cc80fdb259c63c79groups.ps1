<#
    Contains methods for working with groups within the TeamDynamix people database.

    https://app.teamdynamix.com/TDWebApi/Home/section/Group
#>

#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscGroup
{
    <#
    .SYNOPSIS
        Gets a list of groups.
    .DESCRIPTION
        Use Get-TdpscGroup to return a collection of groups.

        This action requires access to the TDPeople application.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER IsActive
        The active status to filter on.
    .PARAMETER NameLike
        The string to use for LIKE-based filtering on the group name.
    .PARAMETER HasAppID
        The ID of the application to filter on. If specified, will only include groups with at least one active member who has been granted access to this application.
    .PARAMETER HasSystemAppName
        The system application to filter on. If specified, will only include groups with at least one active member who has been granted access to this application.
    .EXAMPLE
        Get-TdpscGroup

        Returns all available groups.
    .EXAMPLE
        Get-TdpscGroup -NameLike 'Student'

        Returns all groups that contain the specified Name.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or TeamDynamix.Api.Users.Group or Object[]
        Get-TdpscGroup returns a PSObject object containing the matching groups. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Group#POSTapi/groups/search
    #>

    [CmdletBinding()]
    [OutputType([Object[]], [TeamDynamix.Api.Users.Group[]])]
    Param
    (
		[String]$Bearer,

        [System.Nullable[Boolean]]$IsActive,

        [String]$NameLike,

        [System.Nullable[Int32]]$HasAppID,

        [String]$HasSystemAppName
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

        $search = New-Object -TypeName TeamDynamix.Api.Users.GroupSearch
        $search.IsActive         = $IsActive
        $search.NameLike         = $NameLike
        $search.HasAppID         = $HasAppID
        $search.HasSystemAppName = $HasSystemAppName

        $parms = @{
            Body            = ConvertTo-JsonSerializeObject -InputObject $search
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Post'
            Uri             = (Get-TdpscApiBaseAddress) + 'groups/search'
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Users.Group[]
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

Export-ModuleMember -Function Get-TdpscGroup
