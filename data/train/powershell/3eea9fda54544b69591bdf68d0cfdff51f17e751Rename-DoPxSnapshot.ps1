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
    Renames a snapshot that was previously created in your DigitalOcean environment.
.DESCRIPTION
    The Rename-DoPxSnapshot command renames a snapshot that was previously created in your DigitalOcean environment.
.INPUTS
    digitalocean.snapshot
.OUTPUTS
    digitalocean.snapshot
.NOTES
    This command sends an HTTP PUT request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Rename-DoPxSnapshot -Id 7606405 -NewName "Version 1.1"

    This command sets the name of the snapshot with id 7606405 to "Version 1.1".
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxImage | Rename-DoPxSnapshot -NewName {"Snapshot $($_.name)"}

    This command prepends "Snapshot " to the name of every snapshot in your DigitalOcean environment.
.LINK
    Copy-DoPxSnapshot
.LINK
    Get-DoPxSnapshot
.LINK
    New-DoPxSnapshot
.LINK
    Remove-DoPxSnapshot
.LINK
    Restore-DoPxSnapshot
#>
function Rename-DoPxSnapshot {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType('digitalocean.snapshot')]
    param(
        # The numeric id of the snapshot.
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32]
        $Id,

        # The new name of the snapshot.
        [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $NewName,

        # The access token for your DigitalOcean account, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken,

        # Returns the updated image object to the pipeline. By default, this command does not return anything.
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru
    )
    process {
        Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
            CommandName = 'Set-DoPxObject'
            CommandType = 'Function'
            PreProcessScriptBlock = {
                #region Replace the NewName bound parameter with a parameter hashtable for the action.

                $PSCmdlet.MyInvocation.BoundParameters['Property'] = @{name=$NewName}
                $PSCmdlet.MyInvocation.BoundParameters.Remove('NewName') > $null

                #endregion

                #region Add additional required parameters to the BoundParameters hashtable.

                $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'images'

                #endregion
            }
        }
        Invoke-Snippet -Name ProxyFunction.Process.NoPipeline
        Invoke-Snippet -Name ProxyFunction.End
    }
}

Export-ModuleMember -Function Rename-DoPxSnapshot