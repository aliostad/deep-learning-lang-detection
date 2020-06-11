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
    Renames a DNS records in your DigitalOcean environment.
.DESCRIPTION
    The Rename-DoPxDnsRecord command renames a DNS records in your DigitalOcean environment.
.INPUTS
    digitalocean.domainrecord
.OUTPUTS
    digitalocean.domainrecord
.NOTES
    This command sends an HTTP PUT request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Rename-DoPxDnsRecord -DomainName example.com -Id 4536712 -NewName IPv6

    This command sets the name of the DNS record with id 4536712 that was created for the "example.com" domain to "IPv6".
.LINK
    Add-DoPxDnsRecord
.LINK
    Get-DoPxDnsRecord
.LINK
    Remove-DoPxDnsRecord
#>
function Rename-DoPxDnsRecord {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType('digitalocean.domainrecord')]
    param(
        # The name of a domain with a DNS record that you want to rename.
        [Parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainName,

        # The id of the DNS record you want to rename.
        [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32]
        $Id,

        # The new name that you want to assign to the DNS record.
        [Parameter(Position=2, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $NewName,

        # The access token for your DigitalOcean account, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    process {
        Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
            CommandName = 'Set-DoPxObject'
            CommandType = 'Function'
            PreProcessScriptBlock = {
                #region Reorganize the input parameters.

                $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectId'] = $Id
                $PSCmdlet.MyInvocation.BoundParameters['Id'] = $DomainName
                $PSCmdlet.MyInvocation.BoundParameters['Property'] = @{name=$NewName}
                $PSCmdlet.MyInvocation.BoundParameters.Remove('DomainName') > $null
                $PSCmdlet.MyInvocation.BoundParameters.Remove('NewName') > $null

                #endregion

                #region Add additional required parameters to the BoundParameters hashtable.

                $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'domains'
                $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectUri'] = 'records'

                #endregion
            }
        }
        Invoke-Snippet -Name ProxyFunction.Process.NoPipeline
        Invoke-Snippet -Name ProxyFunction.End
    }
}

Export-ModuleMember -Function Rename-DoPxDnsRecord