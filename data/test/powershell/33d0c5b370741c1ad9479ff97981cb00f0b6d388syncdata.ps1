[IO.Directory]::SetCurrentDirectory((Convert-Path (Get-Location -PSProvider FileSystem)))
$request = [System.Net.WebRequest]::Create("http://api.twitter.com/1/statuses/public_timeline.json")
$response = $request.GetResponse()
$requestStream = $response.GetResponseStream()
$readStream = new-object System.IO.StreamReader $requestStream
new-variable db
$db = $readStream.ReadToEnd()
$readStream.Close()
$response.Close()

$sw = new-object system.IO.StreamWriter(".\statuses\public_timeline.txt")
$sw.writeline($db)
$sw.close()

Remove-Variable db
Remove-Variable sw

$request = [System.Net.WebRequest]::Create("http://api.twitter.com/1/statuses/show/16381619317248000.json")
$response = $request.GetResponse()
$requestStream = $response.GetResponseStream()
$readStream = new-object System.IO.StreamReader $requestStream
new-variable db
$db = $readStream.ReadToEnd()
$readStream.Close()
$response.Close()

$sw = new-object system.IO.StreamWriter(".\statuses\show-existing.txt")
$sw.writeline($db)
$sw.close()

Remove-Variable db
Remove-Variable sw

$request = [System.Net.WebRequest]::Create("http://api.twitter.com/1/statuses/show/163000.json")
$response = $request.GetResponse()
$requestStream = $response.GetResponseStream()
$readStream = new-object System.IO.StreamReader $requestStream
new-variable db
$db = $readStream.ReadToEnd()
$readStream.Close()
$response.Close()

$sw = new-object system.IO.StreamWriter(".\statuses\show-missing.txt")
$sw.writeline($db)
$sw.close()
