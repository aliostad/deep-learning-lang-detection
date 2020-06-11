<?php
$showDate = isset($_GET['showDate']) && $_GET['showDate'] == '0' ? false : true;
$showSteamID = isset($_GET['showSteamID']) && $_GET['showSteamID'] == '0' ? false : true;
$showTeam = isset($_GET['showTeam']) && $_GET['showTeam'] == '0' ? false : true;
?>
<?=$showDate ? $value['sentTime'] . ' ' : ''?><span style="color: <?=htmlentities($value['teamColor'])?>"><?=$showTeam ? '[' . htmlentities($value['team']) . '] ' : ''?><?=$showSteamID ? '(' . $value['steamID'] . ') ' : ''?><?=htmlentities($value['name'])?></span>: <?=htmlentities($value['message'])?><br />