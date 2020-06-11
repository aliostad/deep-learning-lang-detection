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

function Remove-DoPxObject {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([System.Void])]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $RelativeUri,

        [Parameter(Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Id,

        [Parameter(Position=2)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $RelatedObjectUri,

        [Parameter(Position=3)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $RelatedObjectId,

        [Parameter()]
        [ValidateNotNull()]
        [System.Security.SecureString]
        $AccessToken
    )
    try {
        #region If RelatedObjectId is used without the Id parameter, raise an error.

        $PSCmdlet.ValidateParameterDependency('RelatedObjectUri','Id')

        #endregion

        #region If RelatedObjectId is used without the RelatedObjectUri parameter, raise an error.

        $PSCmdlet.ValidateParameterDependency('RelatedObjectId','RelatedObjectUri')

        #endregion

        #region Identify the passthru ShouldProcess parameters.

        $shouldProcessParameters = $PSCmdlet.GetBoundShouldProcessParameters()

        #endregion

        #region Add the relative uri with the endpoint prefix.

        $uri = "${script:DigitalOceanEndpointUri}/$($RelativeUri -replace '^/+|/+$')"

        #endregion

        #region Prefix the Uri parameters with a slash if not present.

        if (-not $PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Id')) {
            $internalId = '' -as [System.String[]]
        } else {
            $internalId = $Id -replace '^([^/])','/$1' -as $Id.GetType()
        }
        if (-not $PSCmdlet.MyInvocation.BoundParameters.ContainsKey('RelatedObjectUri')) {
            $internalRelatedObjectUri = '' -as [System.String]
        } else {
            $internalRelatedObjectUri = $RelatedObjectUri -replace '^([^/])','/$1' -as $RelatedObjectUri.GetType()
        }
        if (-not $PSCmdlet.MyInvocation.BoundParameters.ContainsKey('RelatedObjectId')) {
            $internalRelatedObjectId = '' -as [System.String[]]
        } else {
            $internalRelatedObjectId = $RelatedObjectId -replace '^([^/])','/$1' -as $RelatedObjectId.GetType()
        }

        #endregion

        #region Initialize the web request headers.

        $accessTokenParameter = $PSCmdlet.GetSplattableParameters('AccessToken')
        $headers = Get-DoPxWebRequestHeader @accessTokenParameter

        #endregion

        foreach ($item in $internalId) {
            foreach ($relatedItem in $internalRelatedObjectId) {
                #region Construct the Uri according to the parameter values used in this iteration.

                $endpointUri = $uri
                if ($item) {
                    $endpointUri += $item
                }
                if ($internalRelatedObjectUri) {
                    $endpointUri += "${internalRelatedObjectUri}${relatedItem}"
                }

                #endregion

                #region Invoke the web request.

                Invoke-DoPxWebRequest -Uri $endpointUri -Method Delete -Headers $headers @shouldProcessParameters

                #endregion
            }
        }
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

Export-ModuleMember -Function Remove-DoPxObject