#
# Traverses the target directory and renames files of the form "titleXX.mkv"
#

Param(
	$targetPath = $pwd.Path,
	$show = "",
	$season = "",
	$episodeStart = -1
)

if ( $episodeStart -eq -1 ) {
	$episodes = @(Get-ChildItem $targetPath | where { $_.Name -match ( "$show - s" + ('{0:D2}' -f $season ) ) })
	$latest = 0;
	$episodes | foreach {
		$episode = $_.Name -replace ( "$show - s" + ('{0:D2}' -f $season ) ) + "e"
		$episode = [int]($episode -replace ".mkv")
		if ( $episode -gt $latest ) {
			$latest = $episode
		}
	}
	$episodeStart = $latest+1;
	
	echo "Starting with episode $episodeStart"
}

echo $episodeStart

$folders = @( Get-ChildItem $targetPath | where { $_.Name -match 'title' } | select -property Name )

for ( $i = 0; $i -lt $folders.Length; $i++ ) {
	$source = $folders[$i].Name
	$dest = ( $source -replace '[0-9]{2}', ('{0:D2}' -f ($i + $episodeStart) ) )
	$dest = $dest -replace 'title', ($show + ' - s' + ('{0:D2}' -f $season ) + 'e')
	mv $targetPath/$source "$targetPath/$dest"
}