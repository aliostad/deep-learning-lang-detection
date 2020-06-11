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
    Gets the access token that is being used by default in other DoPx commands.
.DESCRIPTION
    The Get-DoPxDefaultAccessToken command gets the access token that is being used by default in other DoPx commands.
.INPUTS
    None
.OUTPUTS
    System.Security.SecureString
.NOTES
    To learn more about the DigitalOcean REST API security, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> Get-DoPxDefaultAccessToken

    This command gets the access token that is being be used by default in all other DoPx commands.
.LINK
    Clear-DoPxDefaultAccessToken
.LINK
    Set-DoPxDefaultAccessToken
#>
function Get-DoPxDefaultAccessToken {
    [CmdletBinding()]
    [OutputType([System.Security.SecureString])]
    param()
    try {
        #region If there is a default access token set for the module, return it.

        $Script:PSDefaultParameterValues['Get-DoPxWebRequestHeader:AccessToken']

        #endregion
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

Export-ModuleMember -Function Get-DoPxDefaultAccessToken