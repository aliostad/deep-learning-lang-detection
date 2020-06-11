# Check the Planet for new Players and send a message on IRC channel

$programfile = "D:\NFK\IRCBot\bin\irccdctl.exe"
$channelname = "#nfk"
$servername = "wenet"

$wc = New-Object system.Net.WebClient;
$json = $wc.downloadString("http://nfk.pro2d.ru/api.php?action=gsl")

$items = $json | ConvertFrom-Json

foreach ($item in $items)
{
	$player_count = 0
	$bot_count = 0
	
	$players = @()
	foreach ($p in $item.players) {
		$players += $p.name
		if ($p.nick) {
			$player_count ++
		} else {
			$bot_count ++
		}
	}
	$players = $players -join ', '
	
	$gametype = $item.gametype
	$map = $item.map
	$load = $item.load
	
	$pcount = $item.load[0]
	$pmax = $item.load[2]
	echo "$pcount $gametype $pmax"
	$waiting = $FALSE
	# if players == 2 in DM mode
	if ($pcount -eq "1" -and $gametype -eq "DM" -and $pmax -eq "2") { $waiting = $TRUE }
	if ($player_count -ge 3 -and $gametype -eq "DM") { 
		$message = '"' + "$players are playering in ($load) [$gametype] $map. Let's play CTF may be!?" + '"'
		start-process "$programfile" -args "me $servername $channelname $message"
	}
	# if gametype == TDM|CTF|DOM && players == 2
	if ($gametype -eq "TDM" -or $gametype -eq "CTF" -or $gametype -eq "DOM") {
		if ($pcount -eq $pmax-1) { $waiting = $TRUE }
		if ($pcount -eq "2" -or $pcount -eq "5") { $waiting = $TRUE } #sometimes maxplayers is 8, but players waiting for 1 player
	}
	
	if ($waiting)
	{
		$verb = "are"
		if ($player_count -eq 1) { $verb = "is" }
		$ass = gc D:\NFK\IRCBot\bin\ass1.txt | sort{get-random} | select -First 1
		$adds = gc D:\NFK\IRCBot\bin\ass2.txt | sort{get-random} | select -First 1
		
		$message = '"' + "$players $verb waiting for $ass on the Planet: ($load) [$gametype] $map$adds" + '"'
	
		start-process "$programfile" -args "me $servername $channelname $message"
	}
	#"it works"
}