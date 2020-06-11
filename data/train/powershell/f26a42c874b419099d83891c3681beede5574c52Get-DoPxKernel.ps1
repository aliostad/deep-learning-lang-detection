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
    Gets the kernels that are available for a droplet in your DigitalOcean environment.
.DESCRIPTION
    The Get-DoPxKernel command gets the kernels that are available for a droplet in your DigitalOcean environment.
.PARAMETER First
    Get only the specified number of available kernels.
.PARAMETER Skip
    Skip the specified number of available kernels. If this parameter is used in conjunction with the First parameter, the specified number of available kernels will be skipped before the paging support starts counting the first available kernels to return.
.PARAMETER IncludeTotalCount
    Return the total count of available kernels that will be returned before returning the available kernels themselves.
.INPUTS
    digitalocean.droplet
.OUTPUTS
    digitalocean.kernel
.NOTES
    This command sends an HTTP GET request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxKernel -DropletId 4849480

    This command gets a list of all available kernels for the droplet with ID 4849480.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDroplet -Id 4849480 | Get-DoPxKernel

    This command gets a list of all available kernels for the droplet with ID 4849480.
.LINK
    Get-DoPxDroplet
.LINK
    Update-DoPxKernel
#>
function Get-DoPxKernel {
    [CmdletBinding(SupportsPaging=$true)]
    [OutputType('digitalocean.kernel')]
    param(
        # The numeric id of the droplet for which you want the list of available kernels.
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
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
        Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
            CommandName = 'Get-DoPxObject'
            CommandType = 'Function'
            PreProcessScriptBlock = {
                #region Replace the DropletId bound parameter with the Id parameter.

                $PSCmdlet.MyInvocation.BoundParameters['Id'] = $DropletId
                $PSCmdlet.MyInvocation.BoundParameters.Remove('DropletId') > $null

                #endregion

                #region Add additional required parameters to the BoundParameters hashtable.

                $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'droplets'
                $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectUri'] = 'kernels'

                #endregion
            }
        }
        Invoke-Snippet -Name ProxyFunction.Process.NoPipeline
        Invoke-Snippet -Name ProxyFunction.End
    }
}

Export-ModuleMember -Function Get-DoPxKernel