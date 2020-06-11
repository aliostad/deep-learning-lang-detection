Function Get-StringHash([String] $String,$HashName = "MD5"){
$StringBuilder = New-Object System.Text.StringBuilder
[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|
%{[Void]$StringBuilder.Append($_.ToString("x2"))}
$StringBuilder.ToString()}
[String]$Storage = "192.168.0.1"
[String]$User= "monitor"
[String]$Password = "!monitor"
[String]$Command = "show/controller-statistics"
[string]$ToHash = $User + "_" + $Password
[string]$Url = "http://" + $Storage + "/API/"
[string]$hash = Get-StringHash $ToHash
[string]$LoginUrl = $Url + "login/" + $hash
[string]$CommandUrl = $Url + $Command
[string]$ExitUrl = $Url  + "exit"
$WebClient = new-object System.Net.WebClient
[xml]$LoginXml = $webclient.DownloadString($LoginUrl)
$SessionKey = ($LoginXml.RESPONSE.OBJECT.PROPERTY | ?{$_.Name -eq "response"}).innerxml
$webClient.Headers.Add("sessionKey", $SessionKey)
[xml]$Xml = $webclient.DownloadString($CommandUrl)
$webclient.DownloadString($ExitUrl)
$CpuLoad = $Xml.RESPONSE.OBJECT.PROPERTY[1]."#text"
$CpuLoad = $CpuLoad.ToString()
$Iops = $Xml.RESPONSE.OBJECT.PROPERTY[6]."#text"
$Iops = $Iops.ToString()
Write-Host "<?xml version=`"1.0`" encoding=`"Windows-1251`" ?>"
Write-Host "<prtg>"
Write-Host "<result>"
Write-Host "<channel>Controller IOPS</channel>"
Write-Host "<value>$Iops</value>"
Write-Host "</result>"
Write-Host "<result>"
Write-Host "<channel>CPU Load</channel>"
Write-Host "<value>$CpuLoad</value>"
Write-Host "</result>"
Write-Host "</prtg>"