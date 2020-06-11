<?php

include("wp_days_ago-core.php");

$newer = mktime(12, 0, 0, 1, 1, 2015);

/*$older = mktime(12, 59, 59, 1, 1, 2015);
$showYesterday = true;
test($older, $newer, $showYesterday, "Some time in the future");
*/

$older = mktime(11, 59, 59, 1, 1, 2015);
$showYesterday = true;
test($older, $newer, $showYesterday, "Just now");

$older = mktime(11, 59, 59, 1, 1, 2015);
$showYesterday = false;
test($older, $newer, $showYesterday, "Just now");

$older = mktime(11, 59, 0, 1, 1, 2015);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 minute ago");

$older = mktime(11, 59, 0, 1, 1, 2015);
$showYesterday = false;
test($older, $newer, $showYesterday, "1 minute ago");

$older = mktime(11, 1, 0, 1, 1, 2015);
$showYesterday = true;
test($older, $newer, $showYesterday, "59 minutes ago");

$older = mktime(11, 1, 0, 1, 1, 2015);
$showYesterday = false;
test($older, $newer, $showYesterday, "59 minutes ago");

$older = mktime(11, 0, 0, 1, 1, 2015);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 hour ago");

$older = mktime(11, 0, 0, 1, 1, 2015);
$showYesterday = false;
test($older, $newer, $showYesterday, "1 hour ago");

$older = mktime(0, 0, 0, 1, 1, 2015);
$showYesterday = true;
test($older, $newer, $showYesterday, "12 hours ago");

$older = mktime(0, 0, 0, 1, 1, 2015);
$showYesterday = false;
test($older, $newer, $showYesterday, "12 hours ago");

$older = mktime(23, 59, 59, 12, 31, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "Yesterday");

$older = mktime(22, 59, 59, 12, 31, 2014);
$showYesterday = false;
test($older, $newer, $showYesterday, "13 hours ago");

$older = mktime(13, 0, 0, 12, 31, 2014);
$showYesterday = false;
test($older, $newer, $showYesterday, "23 hours ago");

$older = mktime(12, 0, 0, 12, 31, 2014);
$showYesterday = false;
test($older, $newer, $showYesterday, "1 day ago");

$older = mktime(11, 0, 0, 12, 30, 2014);
$showYesterday = false;
test($older, $newer, $showYesterday, "2 days ago");

$older = mktime(12, 0, 0, 12, 30, 2014);
$showYesterday = false;
test($older, $newer, $showYesterday, "2 days ago");

$older = mktime(13, 0, 0, 12, 30, 2014);
$showYesterday = false;
test($older, $newer, $showYesterday, "2 days ago");

$older = mktime(12, 0, 0, 12, 30, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "2 days ago");

$older = mktime(13, 0, 0, 12, 25, 2014);
$showYesterday = false;
test($older, $newer, $showYesterday, "One week ago");

$older = mktime(12, 0, 0, 12, 25, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "One week ago");

$older = mktime(12, 0, 0, 12, 24, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "8 days ago");

$older = mktime(12, 0, 0, 12, 1, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 month ago");

$older = mktime(12, 0, 0, 11, 30, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 month, 1 day ago");

$older = mktime(12, 0, 0, 11, 29, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 month, 2 days ago");

$older = mktime(12, 0, 0, 11, 15, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 month, 16 days ago");

$older = mktime(12, 0, 0, 11, 1, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "2 months ago");

$older = mktime(12, 0, 0, 10, 31, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "2 months, 1 day ago");

$older = mktime(12, 0, 0, 10, 25, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "2 months, 7 days ago");

$older = mktime(0, 0, 0, 1, 1, 2014);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 year ago");

$older = mktime(0, 0, 0, 12, 31, 2013);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 year, 1 day ago");

$older = mktime(0, 0, 0, 12, 30, 2013);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 year, 2 days ago");

$older = mktime(12, 0, 0, 12, 1, 2013);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 year, 1 month ago");

$older = mktime(0, 0, 0, 6, 30, 2013);
$showYesterday = true;
test($older, $newer, $showYesterday, "1 year, 6 months ago");

$older = mktime(0, 0, 0, 1, 1, 2005);
$showYesterday = true;
test($older, $newer, $showYesterday, "10 years ago");

function test($older, $newer, $showYesterday, $expected) {
	$actual = timespanToString(calculateTimespan($older, $newer, $showYesterday), $showYesterday);
	if ($actual == $expected) {
		echo $expected . ": <span style=\"color: green;\">PASS</span><br/>";
	} else {
		echo "<hr/>" . $expected . ": <span style=\"color: red;\">FAIL</span><br/>";
		echo "\$older=" . date("Y-m-d H:i:s" ,$older) . "<br/>";
		echo "\$newer=" . date("Y-m-d H:i:s", $newer) . "<br/>";
		echo "\$showYesterday=" . $showYesterday . "<br/>";
		echo "\$expected=" . $expected . "</br/>";
		echo "\$actual=" . $actual . "<br/>";
		echo "<hr/>";
	}
}

function __($p1, $p2) {
	return ($p1);
}

?>