#Eric Lynema
#PowerShellWeather

#Vars
Try{
. ./config.ps1
$web = New-Object System.Net.WebClient
$weatherDataUrl = "http://api.wunderground.com/api/$api_key/conditions/q/MI/Holland.json"
}
Catch {
write "Please create config.ps1 with `$api_key in it."
Break
}
#load data
$weatherJson = $web.DownloadString($weatherDataUrl)
$weather = ConvertFrom-Json $weatherJson
$members = echo $weather | get-member
ConvertTo-HTML $weather | Out-File C:\Users\epl692\Documents\Weather.html

Invoke-Expression C:\Users\epl692\Documents\Weather.html