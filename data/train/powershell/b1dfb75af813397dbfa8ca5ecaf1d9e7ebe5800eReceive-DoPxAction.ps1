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
    Returns the object associated with a completed action.
.DESCRIPTION
    The Receive-DoPxAction command returns the object associated with a completed action.
.INPUTS
    digitalocean.action
.OUTPUTS
    digitalocean.object
.NOTES
    This command sends an HTTP GET request that includes your access token to the DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Receive-DoPxAction -Id 51666486

    This command returns the object used to invoke the completed action with id 51666486.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxAction -Id 51666486 | Wait-Action | Receive-DoPxAction

    This command waits for the action with id 51666486 to finish running and then returns the object used to invoke that action.
.LINK
    Get-DoPxAction
.LINK
    Wait-DoPxAction
#>
function Receive-DoPxAction {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType('digitalocean.object')]
    param(
        # The numeric id of the action.
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Id,

        # The access token for your DigitalOcean account, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    begin {
        try {
            #region Get a splattable AccessToken parameter.

            $accessTokenParameter = $PSCmdlet.GetSplattableParameters('AccessToken')

            #endregion
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    process {
        try {
            #region Get the current state of the action.

            if ($_.PSTypeNames -contains 'digitalocean.action') {
                $action = $_
            } else {
                $action = Get-DoPxAction -Id $Id @accessTokenParameter
            }

            #endregion

            #region If we have a completed action, return the object it was invoked on to the caller.

            if ($action -and ($action.completed_at -ne $null)) {
                $relativeUri = $action.resource_type
                if ($relativeUri -notmatch 's$') {
                    $relativeUri = "${relativeUri}s"
                }
                Get-DoPxObject -RelativeUri $relativeUri -Id $action.resource_id @accessTokenParameter
            }

            #endregion
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}

Export-ModuleMember -Function Receive-DoPxAction