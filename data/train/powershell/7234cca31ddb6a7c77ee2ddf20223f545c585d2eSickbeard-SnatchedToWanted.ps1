$Server = "triton.addicks.us"
$Port   = "8081"
$ApiKey = "0178c52269488d218027528bcc66f077"
$ssl    = $true

if ($ssl) {
    $urlbase = "https://$server`:$Port/api/$ApiKey/"
    # ignore certificate errors
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    [System.Net.ServicePointManager]::Expect100Continue = {$true}
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::ssl3
} else {
    $urlbase = "http://$server`:$Port/api/$ApiKey/"
}

$url = $urlbase + "?cmd=history&limit=0"

[net.httpWebRequest] $request  = [net.webRequest]::create($url)
[net.httpWebResponse] $response = $request.getResponse()
$responseStream = $response.getResponseStream()
$sr = new-object IO.StreamReader($responseStream)
$result = $sr.ReadToEnd()
$result = ConvertFrom-Json $result
$result = $result.data

$StatusResults = @()
foreach ($r in ($result | where { $_.status -eq "Snatched" })) {
    $Lookup = $result | where { ($_.status -eq "Downloaded") -and ($_.show_name -eq $r.show_name) -and ($_.season -eq $r.season) -and ($_.episode -eq $r.episode) }
    if (!($Lookup)) {
        $url  = $urlbase
        $url += "?cmd=episode.setstatus"
        $url += "&tvdbid=$($r.tvdbid)"
        $url += "&season=$($r.season)"
        $url += "&episode=$($r.episode)"
        $url += "&status=wanted"
        $url
        [net.httpWebRequest] $request  = [net.webRequest]::create($url)
        [net.httpWebResponse] $response = $request.getResponse()
        $responseStream = $response.getResponseStream()
        $sr = new-object IO.StreamReader($responseStream)
        $statusresult = ConvertFrom-Json $sr.ReadToEnd()
        $StatusResult.result
    }
}