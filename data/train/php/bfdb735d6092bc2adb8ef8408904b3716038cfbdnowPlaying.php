<?php
include ("connection.php");
include ("../functions/data.php");
date_default_timezone_set("Europe/London");
	$day = date('l');
	$current_time= date('H:i:s');
	
	$q1="SELECT * FROM showtime WHERE day = '$day'";
	$r1=mysqli_query($dbc, $q1);
	
	while ($show=mysqli_fetch_assoc($r1)) {
		
			$showStart=explode(":", $show['start_time']);
			$showEnd=explode(":", $show['end_time']);
		if ($show['start_time'] <= $current_time && $show['end_time'] > $current_time) {
			
			echo '<div id="nowPlaying" class="nowPlaying">
					<h3>Now Playing</h3>
					<h4>'.$show["dj"].'</h4>
					<h5>'.$show['showtitle'].'</h5>
					<h4>'.$show['genre'].'</h4>
					<h4>'.$showStart[0].':'.$showStart[1].' - '.$showEnd[0].':'.$showEnd[1].'</h4>
				</div>';
			}
	
		}

//	$dateTime = date("l, F jS Y @ H:i:s a");
//	$current_time= DATETIME::createFromFormat('l, F jS Y @ H:i:s a', $dateTime);
//	$day = $current_time->format('l');
//	$current_time= $current_time->format('H:i:s');
//	
//	$q1="SELECT * FROM showtime WHERE day = '$day'";
//	$r1=mysqli_query($dbc, $q1);
//	
//	while ($show=mysqli_fetch_assoc($r1)) {
//		
//		if ($show['start_time'] <= $current_time && $show['end_time'] > $current_time) {
//			
//			$showStart=explode(":", $show['start_time']);
//			$showEnd=explode(":", $show['end_time']);
//			echo '<div id="nowPlaying" class="nowPlaying">
//					<h3>Now Playing</h3>
//					<h4>'.$show["dj"].'</h4>
//					<h5>'.$show['showtitle'].'</h5>
//					<h4>'.$show['genre'].'</h4>
//					<h4>'.$showStart[0].':'.$showStart[1].' - '.$showEnd[0].':'.$showEnd[1].'</h4>
//				</div>';
//			}
//		}
	
?>