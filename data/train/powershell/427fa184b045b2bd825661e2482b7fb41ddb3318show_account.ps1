#get cookie container from authentication $cookieContainer

$showAccountRequest = [System.Net.WebRequest]::Create("https://my.rightscale.com/api/accounts/$account")
$showAccountRequest.Method = "GET"
$showAccountRequest.CookieContainer = $cookieContainer
$showAccountRequest.Headers.Add("X_API_VERSION", "1.5");

[System.Net.WebResponse] $showAccountResponse = $showAccountRequest.GetResponse()
$showAccountResponseStream = $showAccountResponse.GetResponseStream()
$showAccountResponseStreamReader = New-Object System.IO.StreamReader -argumentList $showAccountResponseStream
[string]$showAccountResponseString = $showAccountResponseStreamReader.ReadToEnd()
write-host $showAccountResponseString

# Output:
#<?xml version="1.0" encoding="UTF-8"?>
#<account>
#  <created_at>2012/06/18 23:33:58 +0000</created_at>
#  <updated_at>2012/09/06 00:29:04 +0000</updated_at>
#  <links>
#    <link href="/api/accounts/58765" rel="self"/>
#    <link href="/api/users/57366" rel="owner"/>
#    <link href="/api/clusters/1" rel="cluster"/>
#  </links>
#  <name>PatrickDev</name>
#</account>