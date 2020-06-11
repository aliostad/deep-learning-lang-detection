
filter set-artist([string]$artist) {
    $tag = [TagLib.File]::Create($_.fullname)
    $tag.Tag.AlbumArtists = $artist
    $tag.Tag.Performers = $artist
    $tag.Save()
}

filter set-title([string]$title) {
    $tag = [TagLib.File]::Create($_.fullname)
    $tag.Tag.Title =  $(if ($title) { $title } else { $_.baseName })
    $tag.Save()
}

filter set-album([string]$album) {
    $tag = [TagLib.File]::Create($_.fullname)
    $tag.Tag.Album = $album
    $tag.Save()
}    

filter set-track([int]$track, [int]$trackCount = 0) {
    $tag = [TagLib.File]::Create($_.fullname)
    $tag.Tag.Track = $track
    $tag.Tag.TrackCount = $trackCount
    $tag.Save()
}    

filter set-disc([int]$disc, [int]$discCount = 0) {
    $tag = [TagLib.File]::Create($_.fullname)
    $tag.Tag.Track = $disc
    $tag.Tag.TrackCount = $discCount
    $tag.Save()
}    

function update-trackAndDisc([string]$match = "D(?<disc>[0-9]+)T(?<track>[0-9]+)")
{
    begin {
        $total = 0
        $discs = @{}
    }
    process {
        if ($_.fullname -match $match) {
            $disc = $matches["disc"]
            $track = $matches["track"]
            if( $discs[$disc] ) { $tags = $discs[$disc] } else { $tags = @() }
            $tagFile = [TagLib.File]::Create($_.fullname)
            $tagFile.Tag.Track = $track
            $tagFile.Tag.Disc = $disc
            $tags += $tagFile
            $discs[$disc] = $tags
            $total++
        }
    }
    end {
        foreach ($key in $discs.keys) {
            $tags = $discs[$key]
            $trackCount = $tags.length
            
            foreach ($tagFile in $tags) {
                $tagFile.Tag.TrackCount = $trackCount;
                $tagFile.Tag.DiscCount = $discs.keys.count
                $tagFile.Save()
            }
        }
    }
}