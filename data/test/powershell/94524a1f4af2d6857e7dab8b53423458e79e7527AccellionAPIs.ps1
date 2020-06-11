#       Licensed to the Apache Software Foundation (ASF) under one
#       or more contributor license agreements.  See the NOTICE file
#       distributed with this work for additional information
#       regarding copyright ownership.  The ASF licenses this file
#       to you under the Apache License, Version 2.0 (the
#       "License"); you may not use this file except in compliance
#       with the License.  You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#       Unless required by applicable law or agreed to in writing,
#       software distributed under the License is distributed on an
#       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#       KIND, either express or implied.  See the License for the
#       specific language governing permissions and limitations
#       under the License.
function HMAC-MD5($key, $message)
{
    $encoding = (New-Object Text.UTF8Encoding)
    $keyBytes = $encoding.GetBytes($key)
    $hmacmd5 = New-Object System.Security.Cryptography.HMACMD5(,[byte[]]$keyBytes)
    $messageBytes = $encoding.GetBytes($message)
    $hashmessage = $hmacmd5.ComputeHash($messageBytes)
    [BitConverter]::ToString($hashmessage).Replace("-", "").ToLower()
}

function HTTP-GET($requestUrl, $cookies, $noRedirect)
{
    $request = [net.HttpWebRequest]::Create("$requestUrl")
    $request.Timeout = 2000
    $request.Method = "GET"
    if ($noRedirect)
    {
        $request.AllowAutoRedirect = $false
    }
    if ($cookies)
    {
        $request.Headers.Add("Cookie", $cookies)
    }

    $response = $request.GetResponse()
    $stream = $response.GetResponseStream()
    $reader = (New-Object IO.StreamReader($stream))
    $reader.ReadToEnd(), $response
}

function Get-AccellionLoginUrl($hostname, $applicationId, $secret, $uid)
{
    $apiName = "login"

    $params = "auth_type=md5","uid=$uid","output=wddx","api_token=1"
    $apiParams = [string]::join("&", $params)
    $token = HMAC-MD5 $secret $apiParams
    
    "https://$hostname/seos/$applicationId/$apiName.api?$apiParams&token=$token"
}

function Get-AccellionSessionUrl($loginWddx)
{
    $loginWddx.wddxPacket.data.struct.var | ? {$_.name -eq 'url'} | % {$_.string}
}

function Get-AccellionInboxUrl($hostname, $applicationId, $inboxToken, $lastMailcheckTime)
{
    $lastMailcheckTime = if ($lastMailcheckTime) {$lastMailcheckTime} else {0}
    $findUrl = Get-AccellionFindUrl $hostname $applicationId
    "$findUrl`?method=inbox&last_mailchk_time=$lastMailcheckTime&token=$inboxToken"
}

function Get-AccellionSessionCookies($response)
{
    $response.Headers['Set-Cookie']
}

function Get-AccellionDownloadCookie($sessionCookies, $applicationId, $domain)
{
    $sessionCookies.Substring($sessionCookies.IndexOf("a$applicationId$domain"))
}

function Get-AccellionAPIUrl($apiName, $hostname, $applicationId)
{
    "https://$hostname/seos/$applicationId/$apiName.api"
}

function Get-AccellionFindUrl($hostname, $applicationId)
{
    Get-AccellionAPIUrl "find" $hostname $applicationId
}

function Get-AccellionFileUrls($inboxWddx)
{
    $inboxWddx.wddxPacket.data.struct.var |
    ? {$_.name -eq 'packages'} |
    % {$_.struct.var | 
        % {$_.struct.var |
            ? {$_.name -eq 'package_files'} |
            % {$_.array.struct.var |
                ? {$_.name -eq 'url'} |
                % {$_.string}
            }
        }
    }
}

function Get-AccellionInboxToken($loginWddx)
{
    $loginWddx.wddxPacket.data.struct.var | ? {$_.name -eq 'inbox_token'} | % {$_.string}
}

function Get-AccellionFiles($hostname, $applicationId, $loginSecret, $uid, $domain)
{
    $login, $loginResponse = HTTP-GET (Get-AccellionLoginUrl $hostname $applicationId $loginSecret $uid)
    $loginWddx = [xml]$login
    $content, $sessionResponse = HTTP-GET (Get-AccellionSessionUrl $loginWddx) "" $true
    $sessionCookies = Get-AccellionSessionCookies $sessionResponse
    $downloadCookie = Get-AccellionDownloadCookie $sessionCookies $applicationId $domain
    $inboxToken = Get-AccellionInboxToken $loginWddx
    $inbox, $inboxResponse = HTTP-GET (Get-AccellionInboxUrl $hostname $applicationId $inboxToken)
    $inboxWddx = [xml]$inbox
    Get-AccellionFileUrls ($inboxWddx) | % {HTTP-GET $_ $downloadCookie}
}
