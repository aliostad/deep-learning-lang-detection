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
    Rebuilds a droplet using a new image, rolls a droplet back to the current image, or resets the password for a droplet in your DigitalOcean environment.
.DESCRIPTION
    The Reset-DoPxDroplet command rebuilds a droplet using a new image, rolls a droplet back to the current image, or resets the password for a droplet in your DigitalOcean environment.
    
    By default, Reset-DoPxDroplet will roll a droplet back to its current image default state. You can rebuild a droplet with a different image instead by using the ImageId parameter. To reset the password, use the Password parameter.
.INPUTS
    digitalocean.droplet
.OUTPUTS
    digutalocean.action,digitalocean.droplet
.NOTES
    This command sends an HTTP POST request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Reset-DoPxDroplet -Id 4849480

    This command rolls back all changes since the current image was applied to the droplet with id 4849480.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Reset-DoPxDroplet -Id 4849480 -ImageId wordpress

    This command rebuilds the droplet with id 4849480 using the "wordpress" image.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDroplet -Id 4849480 | Reset-DoPxDroplet -Password

    This command resets the password for the droplet with id 4849480.
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
    Resize-DoPxDroplet
.LINK
    Restart-DoPxDroplet
.LINK
    Start-DoPxDroplet
.LINK
    Stop-DoPxDroplet
#>
function Reset-DoPxDroplet {
    [CmdletBinding(SupportsShouldProcess=$true, DefaultParameterSetName='Image')]
    [OutputType('digitalocean.action')]
    [OutputType('digitalocean.droplet')]
    param(
        # The numeric id of one or more droplets on which you want to reset the password.
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32[]]
        $Id,

        # The id for the base image that will be used when resetting the droplet. This may be a numeric id or a slug. Some images may not be available in all regions. If you don't provide an image id, the droplet will be reset using the current image.
        [Parameter(Position=1, ParameterSetName='Image')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ImageId,

        # Resets the password for a droplet.
        [Parameter(Mandatory=$true, ParameterSetName='Password')]
        [ValidateScript({
            if (-not $_.IsPresent) {
                throw 'Passing false into the Password parameter is not supported.'
            }
            $true
        })]
        [System.Management.Automation.SwitchParameter]
        $Password,

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
        try {
            if ($PSCmdlet.ParameterSetName -eq 'Image') {
                if (-not $PSCmdlet.MyInvocation.BoundParameters.ContainsKey('ImageId')) {
                    #region Reset the droplet to its original state using the current image.

                    $passThruParameters = $PSCmdlet.GetSplattableParameters()
                    $accessTokenParameter = $PSCmdlet.GetSplattableParameters('AccessToken')
                    $droplet = Get-DoPxDroplet -Id $Id @accessTokenParameter
                    Reset-DoPxDroplet -ImageId $droplet.image.id @passThruParameters

                    #endregion
                } else {
                    Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
                        CommandName = 'Invoke-DoPxObjectAction'
                        CommandType = 'Function'
                        PreProcessScriptBlock = {
                            #region Replace the ImageId bound parameter with a parameter hashtable for the action.

                            if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('ImageId')) {
                                $PSCmdlet.MyInvocation.BoundParameters['Parameter'] = @{image=$ImageId}
                                $PSCmdlet.MyInvocation.BoundParameters.Remove('ImageId') > $null
                            }

                            #endregion

                            #region Add additional required parameters to the BoundParameters hashtable.

                            $PSCmdlet.MyInvocation.BoundParameters['Action'] = 'rebuild'
                            $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'droplets'

                            #endregion
                        }
                    }
                    Invoke-Snippet -Name ProxyFunction.Process.NoPipeline
                    Invoke-Snippet -Name ProxyFunction.End
                }
            } else {
                Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
                    CommandName = 'Invoke-DoPxObjectAction'
                    CommandType = 'Function'
                    PreProcessScriptBlock = {
                        #region Add additional required parameters to the BoundParameters hashtable.

                        $PSCmdlet.MyInvocation.BoundParameters['Action'] = 'password_reset'
                        $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'droplets'

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

Export-ModuleMember -Function Reset-DoPxDroplet