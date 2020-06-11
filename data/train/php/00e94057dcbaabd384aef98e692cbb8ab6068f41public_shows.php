<?php

if (! $_GET['no_callback']) {
	echo "_br_shows_callback([\n";
} else {
	echo "[\n";
}

$sep = "\t";
foreach ($shows as $show) {
	if (empty ($show->ticket_link)) {
		unset ($show->ticket_link);
	}
	$show->datetime = $show->date . ' ' . $show->time;
	$show->time = gmdate ('g:ia', strtotime ($show->date . ' ' . $show->time));
	$show->date = gmdate ('M j', strtotime ($show->date));
	echo $sep . json_encode ($show);
	$sep = ",\n\t";
}

if (! $_GET['no_callback']) {
	echo "\n]);";
} else {
	echo "\n]";
}

?>