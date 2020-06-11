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
    Gets the DigitalOcean actions that have been invoked in your DigitalOcean environment.
.DESCRIPTION
    The Get-DoPxAction command gets the DigitalOcean actions that have been invoked in your DigitalOcean environment.

    Without the Id parameter, Get-DoPxAction gets all of the actions that have been invoked in your DigitalOcean environment. You can also use Get-DoPxAction command to get specific actions by passing the action IDs to the Id parameter.
.PARAMETER First
    Get only the specified number of actions.
.PARAMETER Skip
    Skip the specified number of actions. If this parameter is used in conjunction with the First parameter, the specified number of actions will be skipped before the paging support starts counting the first actions to return.
.PARAMETER IncludeTotalCount
    Return the total count of actions that will be returned before returning the actions themselves.
.INPUTS
    None
.OUTPUTS
    digitalocean.action
.NOTES
    This command sends an HTTP GET request that includes your access token to the DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxAction

    This command gets all actions that have been invoked in your DigitalOcean environment.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxAction -Id 51666486

    This command gets the action with id 51666486 from your DigitalOcean environment.
.LINK
    Receive-DoPxAction
.LINK
    Wait-DoPxAction
#>
function Get-DoPxAction {
    [CmdletBinding(SupportsPaging=$true, DefaultParameterSetName='Default')]
    [OutputType('digitalocean.action')]
    param(
        # The numeric id of the action.
        [Parameter(Position=0)]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32[]]
        $Id,

        # The numeric id of the droplet where the action was taken.
        [Parameter(Mandatory=$true, ParameterSetName='DropletAction')]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32[]]
        $DropletId,

        # The numeric id of the image where the action was taken.
        [Parameter(Mandatory=$true, ParameterSetName='ImageAction')]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32[]]
        $ImageId,

        # The access token for your DigitalOcean account, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    begin {
        Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
            CommandName = 'Get-DoPxObject'
            CommandType = 'Function'
            PreProcessScriptBlock = {
                #region Add additional required parameters to the BoundParameters hashtable.

                switch ($PSCmdlet.ParameterSetName) {
                    'DropletAction' {
                        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Id')) {
                            $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectId'] = $Id
                            $PSCmdlet.MyInvocation.BoundParameters.Remove('Id') > $null
                        }
                        $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'droplets'
                        $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectUri'] = 'actions'
                        $PSCmdlet.MyInvocation.BoundParameters['Id'] = $DropletId
                        $PSCmdlet.MyInvocation.BoundParameters.Remove('DropletId') > $null
                        break
                    }
                    'ImageAction' {
                        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Id')) {
                            $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectId'] = $Id
                            $PSCmdlet.MyInvocation.BoundParameters.Remove('Id') > $null
                        }
                        $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'images'
                        $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectUri'] = 'actions'
                        $PSCmdlet.MyInvocation.BoundParameters['Id'] = $ImageId
                        $PSCmdlet.MyInvocation.BoundParameters.Remove('ImageId') > $null
                        break
                    }
                    default {
                        $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'actions'
                        break
                    }
                }

                #endregion
            }
        }
    }
    process {
        Invoke-Snippet -Name ProxyFunction.Process.NoPipeline
    }
    end {
        Invoke-Snippet -Name ProxyFunction.End
    }
}

Export-ModuleMember -Function Get-DoPxAction