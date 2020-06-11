function Execute-HTTPPostCommand(){
    param(
        [string] $target = $null,
        [string] $body = $null
    )

    $username = "pager"
    $password = "411ts"
    $proxy = "webproxy.int.comiccon.com"
#$Post = "action=assign&groups=1173&assigned%5B%5D=U5860&assigned%5B%5D=U4868&assigned%5B%5D=U4729&assigned%5B%5D=U5507&poffcall=on&poncall=on&Save=Save+Changes"
#$Post = "action=assign&groups=1173&assigned[]=U5860&assigned[]=U4868&assigned[]=U4729&assigned[]=U5507&poffcall=on&poncall=on&Save=Save+Changes"

    $webRequest = [System.Net.WebRequest]::Create($target)
    $webRequest.Proxy = new-object -typename system.net.webproxy -argumentlist "http://$proxy"
    $webRequest.ContentType = "text/html"
    $PostStr = [System.Text.Encoding]::UTF8.GetBytes($Post)
    $webRequest.Headers.Add("Accept-Encoding: gzip,deflate")
    $webRequest.Headers.Add("Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7")

    $webrequest.ContentLength = $PostStr.Length
    $webRequest.ServicePoint.Expect100Continue = $false    
    $webRequest.Credentials = New-Object System.Net.NetworkCredential -ArgumentList $username, $password 


    $webRequest.PreAuthenticate = $true
    $webRequest.Method = "POST"

    #$webRequest.Headers.add("Cookie", $CookieContainer.GetCookieHeader($target))

    $requestStream = $webRequest.GetRequestStream()
    $requestStream.Write($PostStr, 0,$PostStr.length)
    $requestStream.Close()

    [System.Net.WebResponse] $resp = $webRequest.GetResponse();
    $rs = $resp.GetResponseStream();
    [System.IO.StreamReader] $sr = New-Object System.IO.StreamReader -argumentList $rs;
    [string] $results = $sr.ReadToEnd();

    $results | out-file "E:\today\20\test.html"

    return $results;

}

$Post = "action=assign&groups=1173&assigned[]=U5860&assigned[]=U4868&assigned[]=U4729&assigned[]=U5507&poffcall=on&poncall=on&Save=Save+Changes"
$URL = "http://pager.int.disenza.com/rotation.php"

Execute-HTTPPostCommand $URL $Post


