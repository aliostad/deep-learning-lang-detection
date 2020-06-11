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
    Gets the domains that have been added to your DigitalOcean environment.
.DESCRIPTION
    The Get-DoPxDomain command gets the domains that have been added to your DigitalOcean environment.

    Without the Id parameter, Get-DoPxDomain gets all of the domains that have been added to your DigitalOcean environment. You can also use Get-DoPxDomain command to get specific domains by passing the domain IDs to the Id parameter or fingerprints to the Fingerprint parameter.
.PARAMETER First
    Get only the specified number of domains.
.PARAMETER Skip
    Skip the specified number of domains. If this parameter is used in conjunction with the First parameter, the specified number of domains will be skipped before the paging support starts counting the first domains to return.
.PARAMETER IncludeTotalCount
    Return the total count of domains that will be returned before returning the domains themselves.
.INPUTS
    None
.OUTPUTS
    digitalocean.domain
.NOTES
    This command sends an HTTP GET request that includes your access token to a DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDomain

    This command gets all domains that have been added to your DigitalOcean environment.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxDomain -Name example.com

    This command gets the domain with name "example.com" from your DigitalOcean environment.
.LINK
    Add-DoPxDomain
.LINK
    Remove-DoPxDomain
#>
function Get-DoPxDomain {
    [CmdletBinding(SupportsPaging=$true)]
    [OutputType('digitalocean.domain')]
    param(
        # The name of the domain.
        [Parameter(Position=0)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Name,

        # The access token for your DigitalOcean environment, in secure string format.
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
                #region Set up the ID properly if a name is being used in the search.

                if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Name')) {
                    $PSCmdlet.MyInvocation.BoundParameters['Id'] = $Name
                    $PSCmdlet.MyInvocation.BoundParameters.Remove('Name') > $null
                }

                #endregion

                #region Add additional required parameters to the BoundParameters hashtable.

                $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'domains'

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

Export-ModuleMember -Function Get-DoPxDomain