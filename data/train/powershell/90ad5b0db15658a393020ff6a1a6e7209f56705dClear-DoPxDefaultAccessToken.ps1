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
    Clears the access token that is being used by default in other DoPx commands from memory.
.DESCRIPTION
    The Clear-DoPxDefaultAccessToken command clears the access token that is being used by default in other DoPx commands from memory.
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    To learn more about the DigitalOcean REST API security, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> Clear-DoPxDefaultAccessToken

    This command clears the access token that is being be used by default in all other DoPx commands. After running this command, you must either explicitly use an access token in other DoPx commands or you must invoke Set-DoPxDefaultAccessToken to set a new default access token.
.LINK
    Get-DoPxDefaultAccessToken
.LINK
    Set-DoPxDefaultAccessToken
#>
function Clear-DoPxDefaultAccessToken {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([System.Void])]
    param()
    try {
        #region If there is an access token stored in the module scope, remove it.

        if ($PSCmdlet.ShouldProcess('AccessToken')) {
            $Script:PSDefaultParameterValues.Remove('Get-DoPxWebRequestHeader:AccessToken')
        }

        #endregion
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

Export-ModuleMember -Function Clear-DoPxDefaultAccessToken