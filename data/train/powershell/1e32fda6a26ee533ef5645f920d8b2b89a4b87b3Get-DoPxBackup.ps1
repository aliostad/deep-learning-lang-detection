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
    Gets the backups that have been created in your DigitalOcean environment.
.DESCRIPTION
    The Get-DoPxBackup command gets the backups that have been created in your DigitalOcean environment.

    Without the DropletId parameter, Get-DoPxBackup gets all of the backups that are available in your DigitalOcean environment. You can also use the Get-DoPxBackup command to get backups for specific droplets by passing droplet IDs to the DropletId parameter.
.PARAMETER First
    Get only the specified number of backups.
.PARAMETER Skip
    Skip the specified number of backups. If this parameter is used in conjunction with the First parameter, the specified number of backups will be skipped before the paging support starts counting the first backup to return.
.PARAMETER IncludeTotalCount
    Return the total count of backups that will be returned before returning the backups themselves.
.INPUTS
    None
.OUTPUTS
    digitalocean.backup
.NOTES
    This command sends an HTTP GET request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxBackup

    This command gets all backups that have been created in your DigitalOcean environment.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxBackup -DropletId 4849480

    This command gets all backups that have been created for the droplet with id 4849480 in your DigitalOcean environment.
.LINK
    Copy-DoPxBackup
.LINK
    Remove-DoPxBackup
.LINK
    Rename-DoPxBackup
.LINK
    Restore-DoPxBackup
#>
function Get-DoPxBackup {
    [CmdletBinding(SupportsPaging=$true)]
    [OutputType('digitalocean.backup')]
    param(
        # The numeric id of a droplet that was backed up.
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
                #region Get all backups from all snapshots.

                $passThruParameters = $PSCmdlet.MyInvocation.BoundParameters
                Get-DoPxDroplet @passThruParameters | Get-DoPxBackup @passThruParameters

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
                        $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectUri'] = 'backups'

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

Export-ModuleMember -Function Get-DoPxBackup