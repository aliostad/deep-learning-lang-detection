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
    Gets the ssh keys that have been added to your DigitalOcean account.
.DESCRIPTION
    The Get-DoPxSshKey command gets the ssh keys that have been added to your DigitalOcean account.

    Without the Id parameter, Get-DoPxSshKey gets all of the ssh keys that have been added to your DigitalOcean account. You can also use Get-DoPxSshKey command to get specific ssh keys by passing the ssh key IDs to the Id parameter or fingerprints to the Fingerprint parameter.
.PARAMETER First
    Get only the specified number of ssh keys.
.PARAMETER Skip
    Skip the specified number of ssh keys. If this parameter is used in conjunction with the First parameter, the specified number of ssh keys will be skipped before the paging support starts counting the first ssh keys to return.
.PARAMETER IncludeTotalCount
    Return the total count of ssh keys that will be returned before returning the ssh keys themselves.
.INPUTS
    None
.OUTPUTS
    digitalocean.sshkey
.NOTES
    This command sends an HTTP GET request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxSshKey

    This command gets all ssh keys that have been added to your DigitalOcean account.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxSshKey -Id 542108

    This command gets the ssh key with id 542108 from your DigitalOcean account.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxSshKey -Fingerprint 0b:87:45:bd:f0:bf:c9:26:fc:79:1c:ea:d2:a3:e5:36

    This command gets the ssh key that has the fingerprint '0b:87:45:bd:f0:bf:c9:26:fc:79:1c:ea:d2:a3:e5:36' from your DigitalOcean account.
.LINK
    Add-DoPxSshKey
.LINK
    Rename-DoPxSshKey
.LINK
    Remove-DoPxSshKey
#>
function Get-DoPxSshKey {
    [CmdletBinding(SupportsPaging=$true,DefaultParameterSetName='Id')]
    [OutputType('digitalocean.sshkey')]
    param(
        # The numeric id of the ssh key.
        [Parameter(Position=0, ParameterSetName='Id')]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32[]]
        $Id,

        # The fingerprint of the ssh key.
        [Parameter(Position=0, Mandatory=$true, ParameterSetName='Fingerprint')]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Fingerprint,

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
                #region Set up the ID properly if a fingerprint is being used in the search.

                if ($PSCmdlet.ParameterSetName -eq 'Fingerprint') {
                    $PSCmdlet.MyInvocation.BoundParameters['Id'] = $Fingerprint
                    $PSCmdlet.MyInvocation.BoundParameters.Remove('Fingerprint') > $null
                }

                #endregion

                #region Add additional required parameters to the BoundParameters hashtable.

                $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'account/keys'

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

Export-ModuleMember -Function Get-DoPxSshKey