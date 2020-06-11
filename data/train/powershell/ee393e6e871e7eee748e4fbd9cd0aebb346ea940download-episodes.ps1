#####################################################
## The Overnightscape Underground Downloader 5000! ##
#####################################################

## List of URLs to download
$RemoteList = "https://bitbucket.org/Rubenerd/rubenerd-hugo/raw/28708c04a6a43dcde2ce8b88c3065d8f86c26bcc/content/post/show/urls.txt"

#####################################################

$ErrorActionPreference = "STOP"

$LocalList = [System.IO.Path]::Combine($pwd.Path, "urls.txt")

Write-Output "--> Downloading show list ..."
$Client = New-Object System.Net.Webclient
$Client.DownloadFile($RemoteList, $LocalList)

foreach ($URL in Get-Content $LocalList) {
    Write-Output "--> Downloading $URL ..."

    $EpisodeFile = [System.IO.Path]::GetFileName($URL)
    $Episode     = [System.IO.Path]::Combine($pwd.Path, $EpisodeFile)
    $Client.DownloadFile($URL, $Episode)

    ## Sleep for 10 seconds between each, to prevent abuse
    Start-Sleep -s 10
}

Write-Output "Done!"

