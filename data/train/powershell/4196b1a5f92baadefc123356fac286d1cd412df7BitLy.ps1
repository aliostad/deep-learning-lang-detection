$username = "mattlaw1975"
$apiKey = "R_e58fab7adf174122a2fb1c6cc0720df7"

Function Get-ShortURL {
	Param($longURL, $login, $apiKey)	
	$url = "http://api.bit.ly/shorten?version=2.0.1&format=xml&longUrl=$longURL&login=$login&apiKey=$apiKey"
	$request = [net.webrequest]::Create($url)
	$responseStream = new-object System.IO.StreamReader($request.GetResponse().GetResponseStream())
	$response = $responseStream.ReadToEnd()
	$responseStream.Close()
	
	$result = [xml]$response
	Write-Output $result.bitly.results.nodeKeyVal.shortUrl
}


Get-ShortURL "http://bgotfs01.silo18.local:10001/results/1000.txt" $username $apiKey

