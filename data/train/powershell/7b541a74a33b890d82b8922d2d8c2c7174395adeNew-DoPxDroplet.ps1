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
    Creates a new droplet in your DigitalOcean environment.
.DESCRIPTION
    The New-DoPxDroplet command creates a new droplet in your DigitalOcean environment.
.INPUTS
    None
.OUTPUTS
    digitalocean.droplet
.NOTES
    This command sends an HTTP POST request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> New-DoPxDroplet -Name RailsServer -ImageId ruby-on-rails -SizeId 4gb -RegionId nyc3 -EnableIPv6

    This command creates a new droplet on nyc3 called RailsServer, using the ruby-on-rails base image, the 4gb size configuration, and with IPv6 enabled.
.LINK
    Disable-DoPxDropletOption
.LINK
    Enable-DoPxDropletOption
.LINK
    Get-DoPxBackup
.LINK
    Get-DoPxDroplet
.LINK
    Get-DoPxKernel
.LINK
    Get-DoPxSnapshot
.LINK
    Remove-DoPxDroplet
.LINK
    Rename-DoPxDroplet
.LINK
    Reset-DoPxDroplet
.LINK
    Resize-DoPxDroplet
.LINK
    Restart-DoPxDroplet
.LINK
    Start-DoPxDroplet
.LINK
    Stop-DoPxDroplet
#>
function New-DoPxDroplet {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType('digitalocean.droplet')]
    param(
        # The name of the droplet.
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Name,

        # The id for the base image that will be used when creating the droplet. This may be a numeric id or a slug. Some images may not be available in all regions.
        [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ImageId,

        # The id for the size configuration that will be used when creating the droplet. Consult your region settings to see which size configurations are supported.
        [Parameter(Position=2, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $SizeId,

        # The id for the region that you wish to deploy in. You can only deploy droplets in regions that are marked as available.
        [Parameter(Position=3, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $RegionId,

        # A collection of SSH key IDs or fingerprints that you want embedded in the Droplet's root environment upon creation.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [System.String[]]
        $SshKeys = @(),

        # Enables automatic backup on the droplet upon creation. By default, automatic backup is disabled. This can only be enabled when a droplet is created.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [System.Management.Automation.SwitchParameter]
        $EnableAutomaticBackup = $false,

        # Enables IPv6 on the droplet upon creation. By default, IPv6 is disabled. IPv6 is not available in all regions.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [System.Management.Automation.SwitchParameter]
        $EnableIPv6 = $false,

        # Enables private networking on the droplet upon creation. By default, private networking is disabled. Private networking is not available in all regions.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [System.Management.Automation.SwitchParameter]
        $EnablePrivateNetworking = $false,

        # User data that you wish to add to the droplet. User data is not supported in all regions. To see if a region supports user data, check whether or not it supports the "metadata" feature.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [System.String]
        $UserData = $null,

        # The access token for your DigitalOcean environment, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    process {
        try {
            #region Remove any parameters that will not be passed through.

            foreach ($parameterName in 'Name','ImageId','SizeId','RegionId','SshKeys','EnableAutomaticBackup','EnableIPv6','EnablePrivateNetworking','UserData') {
                if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey($parameterName)) {
                    $PSCmdlet.MyInvocation.BoundParameters.Remove($parameterName) > $null
                }
            }

            #endregion

            foreach ($item in $Name) {
                Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
                    CommandName = 'New-DoPxObject'
                    CommandType = 'Function'
                    PreProcessScriptBlock = {
                        #region Identify the endpoint that is used when creating a droplet.

                        $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'droplets'

                        #endregion

                        #region Identify the properties that will be assigned to the new droplet.

                        $PSCmdlet.MyInvocation.BoundParameters['Property'] = @{
                              name = $item
                            region = $RegionId
                              size = $SizeId
                             image = $ImageId
                        }
                        if ($SshKeys) {
                            $PSCmdlet.MyInvocation.BoundParameters.Property['ssh_keys'] = $SshKeys
                        }
                        if ($EnableAutomaticBackup) {
                            $PSCmdlet.MyInvocation.BoundParameters.Property['backups'] = $true
                        }
                        if ($EnableIPv6) {
                            $PSCmdlet.MyInvocation.BoundParameters.Property['ipv6'] = $true
                        }
                        if ($EnablePrivateNetworking) {
                            $PSCmdlet.MyInvocation.BoundParameters.Property['private_networking'] = $true
                        }
                        if ($UserData) {
                            $PSCmdlet.MyInvocation.BoundParameters.Property['user_data'] = $UserData
                        }                

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

Export-ModuleMember -Function New-DoPxDroplet