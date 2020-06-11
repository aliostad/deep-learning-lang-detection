
#IMPORTANT!: disable ssl validation errors
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

#quick and dirty
Invoke-RestMethod -Uri  "https://gdata.youtube.com/feeds/api/videos?v=2&q=PowerShell" | Format-Table -AutoSize

#sweet piping
(Invoke-RestMethod -URI "http://www.seismi.org/api/eqs").earthquakes | Select-Object -First 10 | Format-Table –AutoSize

#pass basic auth as base64 header
function example1()
{

    $username = "Administrator"
    $password = "PASSWORD"
    $uri = "http://www.seismi.org/api/eqs"

    #headers
    #manual basic auth
    $dictionary = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f$username,$password)))
    $dictionary.Add("Authorization",$base64AuthInfo)

    #$dictionary.Add("Accept","application/json")
    #$dictionary.Add("Connection", "keep_alive")

    Invoke-RestMethod -Uri $uri -Method GET -Headers $dictionary -Verbose
}

#pass a true credential
function example2()
{
    $username = "Administrator"
    $password = "PASSWORD"
    $uri = "http://www.seismi.org/api/eqs"

    $secPw = ConvertTo-SecureString $password -AsPlainText -Force
    $cred = New-Object PSCredential -ArgumentList $username,$secPw

    Invoke-RestMethod -Uri $uri -Method GET -Credential $cred -Verbose
}


