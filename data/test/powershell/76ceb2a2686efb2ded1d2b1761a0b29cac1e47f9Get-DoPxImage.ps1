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
    Gets the DigitalOcean images that are available in your DigitalOcean environment.
.DESCRIPTION
    The Get-DoPxImage command gets the DigitalOcean images that are available in your DigitalOcean environment. These may be images of public Linux distributions or applications, snapshots of droplets, or automatic backup images of droplets.

    Without the Id parameter, Get-DoPxImage gets all of the images that are available in your DigitalOcean environment. You can also use Get-DoPxImage command to get specific images by passing the image IDs to the Id parameter.
.PARAMETER First
    Get only the specified number of images.
.PARAMETER Skip
    Skip the specified number of images. If this parameter is used in conjunction with the First parameter, the specified number of images will be skipped before the paging support starts counting the first images to return.
.PARAMETER IncludeTotalCount
    Return the total count of images that will be returned before returning the images themselves.
.INPUTS
    None
.OUTPUTS
    digitalocean.image
.NOTES
    This command sends an HTTP GET request that includes your access token to the DigitalOcean REST API v2 endpoint. To learn more about the DigitalOcean REST API, consult the DigitalOcean API documentation online at https://developers.digitalocean.com.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxImage

    This command gets all images that are available in your DigitalOcean environment.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxImage -Id 5142677

    This command gets the image with id 5142677 from your DigitalOcean environment.
.EXAMPLE
    PS C:\> $accessToken = ConvertTo-SecureString -String a91a22c7d3c572306e9d6ebfce5f1f697bd7fe8d910d9497ca0f75de2bb37a32 -AsPlainText -Force
    PS C:\> Set-DoPxDefaultAccessToken -AccessToken $accessToken
    PS C:\> Get-DoPxImage -Id wordpress

    This command gets the image with the slug "wordpress" from your DigitalOcean environment.
.LINK
    Get-DoPxBackup
.LINK
    Get-DoPxSnapshot
#>
function Get-DoPxImage {
    [CmdletBinding(SupportsPaging=$true)]
    [OutputType('digitalocean.action')]
    param(
        # The numeric id or slug of the image.
        [Parameter(Position=0)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Id,

        # The access token for your DigitalOcean account, in secure string format.
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
                #region Add additional required parameters to the BoundParameters hashtable.

                $PSCmdlet.MyInvocation.BoundParameters['RelativeUri'] = 'images'

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

Export-ModuleMember -Function Get-DoPxImage