<?php
// variables
$filename = "file.csv";
$org_path = "/path/to/file/original/";
$save_path = "/path/to/file/save/";
// save origial timestamp, geht auch ueber stat
$org_time = filemtime($org_path.$filename);
// debug
echo date("F d Y H:i:s.", $org_time);
// copy file-contents
	// check if folder exists
if (!file_exists($save_path)) {
	mkdir($save_path, 0777, true);
};
file_put_contents($save_path.$filename, file_get_contents($org_path.$filename));
// change timestamp
touch($save_path.$filename, $org_time);
// debug
echo date("F d Y H:i:s.", filemtime($save_path.$filename));
?>