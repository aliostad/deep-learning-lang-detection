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
    Adds a domain to your DigitalOcean environment.
.DESCRIPTION
    The Add-DoPxDomain command adds a domains to your DigitalOcean environment. Domain resources are domain names that you have purchased from a domain name registrar that you are managing through the DigitalOcean DNS interface.
    
    When you add a domain to your DigitalOcean environment, DigitalOcean automatically creates NS records to associate that domain with a droplet that is in your DigitalOcean environment on each of the DigitalOcean DNS servers.
.INPUTS
    None
.OUTPUTS
    digitalocean.domain
.NOTES
    This command sends an HTTP POST request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Add-DoPxDomain -Name example.com -IPAddress 192.241.104.96

    This command adds a domain named example.com to your DigitalOcean environment and associates it with the IP address 192.241.104.96.
.LINK
    Get-DoPxDomain
.LINK
    Get-DoPxDroplet
.LINK
    Remove-DoPxDomain
#>
function Add-DoPxDomain {
    [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName='Droplet')]
    [OutputType('digitalocean.domain')]
    param(
        # The name of the domain.
        [Parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        # The IP address of the droplet that you want to associate with the domain.
        [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='Droplet')]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [Alias('Id')]
        [System.Int32]
        $DropletId,

        # The IP address of the droplet that you want to associate with the domain.
        [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='IPAddress')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $IPAddress,

        # The access token for your DigitalOcean environment, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    process {
        try {
            if ($PSCmdlet.ParameterSetName -eq 'Droplet') {
                $accessTokenParameter = $PSCmdlet.GetSplattableParameters('AccessToken')
                if ($_.PSTypeNames -contains 'digitalocean.droplet') {
                    $droplet = $_
                } else {
                    $droplet = Get-DoPxDroplet -Id $DropletId @accessTokenParameter
                }
                Add-DoPxDomain -Name $Name -IPAddress $droplet.networks.v4.ip_address @accessTokenParameter
            } else {
                Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
                    CommandName = 'New-DoPxObject'
                    CommandType = 'Function'
                    PreProcessScriptBlock = {
                        #region Identify the endpoint that is used when adding a domain.

                        $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'domains'

                        #endregion

                        #region Identify the properties that will be assigned to the domain you are adding.

                        $PSCmdlet.MyInvocation.BoundParameters['Property'] = @{
                                  name = $Name
                            ip_address = $IPAddress
                        }
                        $PSCmdlet.MyInvocation.BoundParameters.Remove('Name') > $null
                        $PSCmdlet.MyInvocation.BoundParameters.Remove('IPAddress') > $null

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

Export-ModuleMember -Function Add-DoPxDomain