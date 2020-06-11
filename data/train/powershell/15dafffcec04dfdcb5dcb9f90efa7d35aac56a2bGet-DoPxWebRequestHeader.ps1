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

function Get-DoPxWebRequestHeader {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    try {
        #region Get a BSTR pointer to the access token.

        $bstrAccessToken = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($AccessToken)

        #endregion

        #region Create the web request header with the default values that are always passed in.

        $headers = @{
            # Always specify that we want JSON data (even errors should come back as JSON)
            'Accept' = 'application/json'
            # Authorization token
            'Authorization' = "Bearer $([Runtime.InteropServices.Marshal]::PtrToStringAuto($bstrAccessToken))"
        }

        #endregion

        #region Return the headers to the caller.

        $headers

        #endregion
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    } finally {
        #region Free our BSTR pointer.

        if ($bstrAccessToken -ne $null) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstrAccessToken)
        }

        #endregion
    }
}