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
    Starts a droplet that is currently turned off in your DigitalOcean environment.
.DESCRIPTION
    The Start-DoPxDroplet command starts a droplet that is currently turned off in your DigitalOcean environment.
.INPUTS
    digitalocean.droplet
.OUTPUTS
    digutalocean.action,digitalocean.droplet
.NOTES
    This command sends an HTTP POST request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Start-DoPxDroplet -Id 4849480

    This command starts the droplet with id 4849480.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDroplet | Where-Object {$_.Status -eq 'off'} | Start-DoPxDroplet

    This command starts all droplets that are currently turned off.
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
    New-DoPxDroplet
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
    Stop-DoPxDroplet
#>
function Start-DoPxDroplet {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType('digitalocean.action')]
    [OutputType('digitalocean.droplet')]
    param(
        # The numeric id of one or more droplets that you want to start.
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32[]]
        $Id,

        # The access token for your DigitalOcean environment, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken,

        # Waits for the action to complete, and then returns the updated object to the pipeline. By default, this command returns the action to the pipeline.
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Wait
    )
    process {
        Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
            CommandName = 'Invoke-DoPxObjectAction'
            CommandType = 'Function'
            PreProcessScriptBlock = {
                #region Add additional required parameters to the BoundParameters hashtable.

                $PSCmdlet.MyInvocation.BoundParameters['Action'] = 'power_on'
                $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'droplets'

                #endregion
            }
        }
        Invoke-Snippet -Name ProxyFunction.Process.NoPipeline
        Invoke-Snippet -Name ProxyFunction.End
    }
}

Export-ModuleMember -Function Start-DoPxDroplet