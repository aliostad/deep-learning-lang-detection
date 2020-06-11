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
    Disables automatic backup on a droplet in your DigitalOcean environment.
.DESCRIPTION
    The Disable-DoPxDropletOption command disables automatic backup on a droplet in your DigitalOcean environment.
.INPUTS
    digitalocean.droplet
.OUTPUTS
    digutalocean.action,digitalocean.droplet
.NOTES
    This command sends an HTTP POST request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Disable-DoPxDropletOption -DropletId 4849480 -AutomaticBackup

    This command disables automatic backup on the droplet with id 4849480.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDroplet | Disable-DoPxDropletOption -AutomaticBackup

    This command disables automatic backup on all droplets in your DigitalOcean environment.
.LINK
    Enable-DoPxDropletOption
.LINK
    Get-DoPxDroplet
#>
function Disable-DoPxDropletOption {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType('digitalocean.action')]
    [OutputType('digitalocean.droplet')]
    param(
        # The numeric id of one or more droplets with options that you want to enable.
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [Alias('Id')]
        [System.Int32[]]
        $DropletId,

        # Disables automatic backup of the droplet.
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            if (-not $_.IsPresent) {
                throw 'Passing false into the AutomaticBackup parameter is not supported.'
            }
            $true
        })]
        [System.Management.Automation.SwitchParameter]
        $AutomaticBackup,

        # The access token for your DigitalOcean account, in secure string format.
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
                #region Replace the DropletId parameter with the Id parameter.

                $PSCmdlet.MyInvocation.BoundParameters['Id'] = $DropletId
                $PSCmdlet.MyInvocation.BoundParameters.Remove('DropletId') > $null

                #endregion

                #region Add additional required parameters to the BoundParameters hashtable.

                $PSCmdlet.MyInvocation.BoundParameters['Action'] = 'disable_backups'
                $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'droplets'

                #endregion
            }
        }
        Invoke-Snippet -Name ProxyFunction.Process.NoPipeline
        Invoke-Snippet -Name ProxyFunction.End
    }
}

Export-ModuleMember -Function Disable-DoPxDropletOption