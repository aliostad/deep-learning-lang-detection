param ([String] $screenName = "theblaze")

$client = New-Object System.Net.WebClient
$idUrl = "https://api.twitter.com/1/users/show.json?screen_name=$ScreenName"
$data = $client.DownloadString($idUrl)

$start = 0

$findStr = '"id":'
do {
    $start = $data.IndexOf($findStr, $start + 1)
    if ($start -gt 0) {
        $start += $findStr.Length
        $end = $data.IndexOf(',', $start)
        $userId = $data.SubString($start, $end-$start)
    }
} while ($start -le $data.Length -and $start -gt 0)

$feed = "http://twitter.com/statuses/user_timeline/$userId.rss"

$feed