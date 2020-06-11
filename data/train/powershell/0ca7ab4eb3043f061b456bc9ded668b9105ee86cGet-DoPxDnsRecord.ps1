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
    Gets the DNS records that have been created in your DigitalOcean environment.
.DESCRIPTION
    The Get-DoPxDnsRecord command gets the DNS records that have been created in your DigitalOcean environment.

    Without the DomainName parameter, Get-DoPxDnsRecord gets all of the DNS records that are available in your DigitalOcean environment. You can also use the Get-DoPxDnsRecord command to get DNS records for specific domains by passing domain names to the DomainName parameter.
.PARAMETER First
    Get only the specified number of DNS records.
.PARAMETER Skip
    Skip the specified number of DNS records. If this parameter is used in conjunction with the First parameter, the specified number of DNS records will be skipped before the paging support starts counting the first DNS record to return.
.PARAMETER IncludeTotalCount
    Return the total count of DNS records that will be returned before returning the DNS records themselves.
.INPUTS
    None
.OUTPUTS
    digitalocean.domainrecord
.NOTES
    This command sends an HTTP GET request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDnsRecord

    This command gets all DNS records that have been created in your DigitalOcean environment.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDnsRecord -DomainName example.com

    This command gets all DNS records that have been created for the domain with name "example.com" in your DigitalOcean environment.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDnsRecord -DomainName example.com -Id 4536712

    This command gets the DNS record with ID 4536712 that has been created for the domain with name "example.com" in your DigitalOcean environment.
.LINK
    Add-DoPxDnsRecord
.LINK
    Remove-DoPxDnsRecord
.LINK
    Rename-DoPxDnsRecord
#>
function Get-DoPxDnsRecord {
    [CmdletBinding(SupportsPaging=$true)]
    [OutputType('digitalocean.domainrecord')]
    param(
        # The name of a domain you are interested in.
        [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [System.String[]]
        $DomainName,

        # The DNS record IDs you are interested in.
        [Parameter(Position=1)]
        [ValidateNotNull()]
        [ValidateRange(1,[System.Int32]::MaxValue)]
        [System.Int32[]]
        $Id,

        # The access token for your DigitalOcean account, in secure string format.
        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    process {
        try {
            if (-not $PSCmdlet.MyInvocation.BoundParameters.ContainsKey('DomainName')) {
                #region Get all DNS records from all domains.

                $idParameter = $PSCmdlet.GetSplattableParameters('Id')
                $accessTokenParameter = $PSCmdlet.GetSplattableParameters('AccessToken')
                Get-DoPxDomain @accessTokenParameter | Get-DoPxDnsRecord @idParameter @accessTokenParameter

                #endregion
            } else {
                Invoke-Snippet -Name ProxyFunction.Begin -Parameters @{
                    CommandName = 'Get-DoPxObject'
                    CommandType = 'Function'
                    PreProcessScriptBlock = {
                        #region Reorganize the input parameters.

                        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Id')) {
                            $PSCmdlet.MyInvocation.BoundParameters['RelatedObjectId'] = $Id
                            $PSCmdlet.MyInvocation.BoundParameters.Remove('Id') > $null
                        }
                        $PSCmdlet.MyInvocation.BoundParameters['Id'] = $DomainName
                        $PSCmdlet.MyInvocation.BoundParameters.Remove('DomainName') > $null

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
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}

Export-ModuleMember -Function Get-DoPxDnsRecord