$API = "cc433e68c49ff5ec77fe410a221b7322"
$Location = "hanoi,vn"
$Id = "1561096"
$Format = "json" #xml or json
$Unit = "=metric" # metric: Celsius or imperial: Fahrenheit 
$url = 'http://api.openweathermap.org/data/2.5/forecast?id={0}&appid={1}&mode={2}&units=metric' -f $Id, $API, $Format, $Unit
$webclient = New-Object System.Net.WebClient
$resp = $webClient.DownloadString($url)
write-host $resp
read-host "Complete"