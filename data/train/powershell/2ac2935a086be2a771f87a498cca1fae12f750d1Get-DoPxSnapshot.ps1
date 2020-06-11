<#############################################################################
The DoPx module provides a rich set of commands that extend the automation
capabilities of the DigitalOcean (DO) cloud service. These commands make it
easier to manage your DigitalOcean environment from Windows PowerShell. When
used with the LinuxPx module, you can manage your entire DigitalOcean
environment from one shell.

Copyright 2014 Kirk Munro

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#############################################################################>

<#
.SYNOPSIS
    Gets the snapshots that are available in your DigitalOcean account.
.DESCRIPTION
    The Get-DoPxSnapshot command gets the snapshots that are available in your DigitalOcean account.

    Without the DropletId parameter, Get-DoPxSnapshot gets all of the snapshots that are available in your DigitalOcean account. You can also use Get-DoPxSnapshot command to get snapshots for a specific droplet by passing the droplet IDs to the DropletId parameter.
.PARAMETER First
    Get only the specified number of snapshots.
.PARAMETER Skip
    Skip the specified number of snapshots. If this parameter is used in conjunction with the First parameter, the specified number of snapshots will be skipped before the paging support starts counting the first snapshots to return.
.PARAMETER IncludeTotalCount
    Return the total count of snapshots that will be returned before returning the snapshots themselves.
.INPUTS
    None
.OUTPUTS
    digitalocean.snapshot
.NOTES
    This command sends an HTTP GET request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxSnapshot

    This command gets all snapshots that have been created in your DigitalOcean environment.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxSnapshot -DropletId 4849480

    This command gets all snapshots that have been created from the droplet with id 4849480 in your DigitalOcean environment.
.LINK
    Copy-DoPxSnapshot
.LINK
    New-DoPxSnapshot
.LINK
    Remove-DoPxSnapshot
.LINK
    Rename-DoPxSnapshot
.LINK
    Restore-DoPxSnapshot
#>
function Get-DoPxSnapshot {
    [CmdletBinding(SupportsPaging=$true)]
    [OutputType('digitalocean.snapshot')]
    param(
        # The numeric id of a droplet where a snapshot was taken.
        [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [Alias('Id')]
        [System.Int32[]]
        $DropletId,

        # The access token for your DigitalOcean account, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    process {
        try {
            if (-not $PSCmdlet.MyInvocation.BoundParameters.ContainsKey('DropletId')) {
                #region Get all snapshots from all droplets.

                $passThruParameters = $PSCmdlet.MyInvocation.BoundParameters
                Get-DoPxDroplet @passThruParameters | Get-DoPxSnapshot @passThruParameters

                #endregion
            } else {
                Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
                    CommandName = 'Get-DoPxObject'
                    CommandType = 'Function'
                    PreProcessScriptBlock = {
                        #region Move the id from the DropletId parameter to the Id parameter.

                        $PSCmdlet.MyInvocation.BoundParameters['Id'] = $DropletId
                        $PSCmdlet.MyInvocation.BoundParameters.Remove('DropletId') > $null

                        #endregion

                        #region Add additional required parameters to the BoundParameters hashtable.

                        $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'droplets'
                        $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectUri'] = 'snapshots'

                        #endregion
                    }
                }
                Invoke-Snippet -Name ProxyFunction.Process.NoPipeline
                Invoke-Snippet -Name ProxyFunction.End
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}

Export-ModuleMember -Function Get-DoPxSnapshot