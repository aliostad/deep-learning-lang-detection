function New-Player
    {
    return New-Object PSObject -Property @{ CurrentlyPlayingSong = $null; IsPlaying = $false; }
    }

function Start-Playing( $player, $song )
    {
    $player.CurrentlyPlayingSong = $song;
    $player.IsPlaying = $true;
    }

function Pause-Playing( $player )
    {
    $player.IsPlaying = true;
    }

function Resume-Playing( $player )
    {
    if ( $player.IsPlaying) 
        {
        throw "song is already playing";
        }
    $player.isPlaying = true;
    }

function Save-Favorite( $player )
    {
    Save-SongAsFavorite $player.CurrentlyPlayingSong $true;      
    }


