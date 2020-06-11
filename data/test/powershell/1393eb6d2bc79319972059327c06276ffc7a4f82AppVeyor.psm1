# Copyright 2013 Appveyor Systems Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Version: 1.0

# config
$config = @{}

# context
$script:context = @{}
$currentContext = $script:context
$currentContext.appveyorApiUrl = "https://ci.appveyor.com"
$currentContext.appveyorApiAccessKey = $null
$currentContext.appveyorApiSecretKey = $null
$currentContext.appveyorApiAccountId = $null

function Get-AppveyorProject
{
    param (
        [Parameter(Mandatory=$false)]
        [int]$Id,

        [Parameter(Mandatory=$false)]
        [string]$Name
    )

    if($Name)
    {
        # get project by name
        Invoke-ApiGet "/api/projects?name=$Name"
    }
    elseif($Id)
    {
        # get project by ID
        Invoke-ApiGet "/api/projects?id=$Id"
    }
    else
    {
        # return all projects
        Invoke-ApiGet "/api/projects"
    }
}

# T /api/projects/version?projectName=test-web&versionName=1.0.5
function Get-AppveyorProjectVersion
{
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Parameter(Mandatory=$true)]
        [string]$Version
    )

    # get project version
    Invoke-ApiGet "/api/projects/version?projectName=$Name&versionName=$Version"
}

function Invoke-ApiGet
{
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]$resourceUri
    )

    $headers = @{
        "Authorization" = Get-AuthorizationHeaderValue
    }

    $url = Get-ApiResourceUrl -resourceUri $resourceUri
    return Invoke-RestMethod -Uri $url -Headers $headers -Method Get
}

function Get-ApiResourceUrl
{
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]$resourceUri
    )

    return $currentContext.appveyorApiUrl.TrimEnd('/') + "/" + $resourceUri.TrimStart("/")
}

function Set-AppveyorConnection
{
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]$apiAccessKey,

        [Parameter(Position=1, Mandatory=$true)]
        [string]$apiSecretKey,

        [Parameter(Mandatory=$false)]
        [int]$accountId,

        [Parameter(Mandatory=$false)]
        [string]$apiUrl
    )

    $currentContext.appveyorApiAccessKey = $apiAccessKey
    $currentContext.appveyorApiSecretKey = $apiSecretKey

    if($accountId)
    {
        $currentContext.appveyorApiAccountId = $accountId
    }

    if($apiUrl)
    {
        $currentContext.appveyorApiUrl = $apiUrl
    }
}

function Get-AuthorizationHeaderValue
{
    $apiAccessKey = $currentContext.appveyorApiAccessKey
    $apiSecretKey = $currentContext.appveyorApiSecretKey
    $accountId = $currentContext.appveyorApiAccountId

    if($apiAccessKey -eq $null -or $apiSecretKey -eq $null)
    {
        throw "Call Set-AppveyorConnection <api-access-key> <api-secret-key> to initialize API security context"
    }

    $timestamp = [DateTime]::UtcNow.ToString("r")

    # generate signature
    $stringToSign = $timestamp
	$secretKeyBytes = [byte[]]([System.Text.Encoding]::ASCII.GetBytes($apiSecretKey))
	$stringToSignBytes = [byte[]]([System.Text.Encoding]::ASCII.GetBytes($stringToSign))
	
	[System.Security.Cryptography.HMACSHA1] $signer = New-Object System.Security.Cryptography.HMACSHA1(,$secretKeyBytes)
	$signatureHash = $signer.ComputeHash($stringToSignBytes)
	$signature = [System.Convert]::ToBase64String($signatureHash)

    $headerValue = "HMAC-SHA1 accessKey=`"$apiAccessKey`", timestamp=`"$timestamp`", signature=`"$signature`""
    if($accountId)
    {
        $headerValue = $headerValue + ", accountId=`"$accountId`""
    }
    return $headerValue
}

# export module members
Export-ModuleMember -Function `
    Set-AppveyorConnection, `
    Get-AppveyorProject, Get-AppveyorProjectVersion