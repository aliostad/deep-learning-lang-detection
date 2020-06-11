Set-Location $PSScriptRoot

$shows = Get-WlpsShow -ShowIdNumber 401
foreach($show in $shows){
   #$episodes = $show |  Get-WlpsEpisodes
   # För demo tar vi bara den sista episoden
   $episodes = $show |  Get-WlpsEpisodes | Select-Object -Last 1
   md .\$($show.title)
    foreach ($episode in $episodes){
        $episode | Select-Object title, show
        $stream = Get-WlpsStreams -url $episode.url | Sort-Object quality_kbps | Select-Object -First 1 
        $filename = $episode.title.Trim() -replace '[\\//*?"<>|]',  "_"
        $filename = $filename -replace '[:]',  ";"
        $filename = ".\"+$show.title+"\"+$filename+"."+$stream.suffixHint
        $url = $stream.url 
        if(Test-Path $filename){
            Write-Host $filename -ForegroundColor DarkYellow
        } else {
            Write-Host $filename -ForegroundColor Green
            .\ffmpeg.exe -i "$url" -acodec copy -vcodec copy -absf aac_adtstoasc "$filename"
        } 
    }
}

#$episodes = Get-WlpsEpisodes -Name "Bert och Ernie på äventyr"


#[System.Text.RegularExpressions.Regex]::Replace("Aisopos teater - 2/7 07:00", "[^a-zA-Z0-9]", " ")