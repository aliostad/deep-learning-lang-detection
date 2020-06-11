<?php class fn_frame {

var $db;
var $id;
var $base;

function insert($frameDoc,$html) {
	$show=  $frameDoc.".open();";   	   
	$show.= $frameDoc.".write(\"".$html."\");";   	   
	$show.= $frameDoc.".close();";   	   
	return $show;
}

function block_main_st() {
	$show='<div id=\"idBlockMain\">';   	   
	return $show;
}

function block_nd() {
	$show='</div>';   	   
	return $show;
}

function open($frameDoc) {
	$show=  $frameDoc.".open();";   	   
	return $show;
}

function close($frameDoc) {
	$show=  $frameDoc.".open();";   	   
	return $show;
}

function write($frameDoc,$html) {
	$show= $frameDoc.".write(\"".$html."\");";   	   
	return $show;
}

function start() {
	$show='<html><head>';
	return $show;
}

function style() {
	$show='<style>';
	$show.='body, div, p, td {font-size:12px; font-family:tahoma; margin:0px; padding:0px;}';
	$show.='body {margin:5px;}';
	$show.='</style>';
	return $show;
}

function body() {
	$show='</head>';
	$show.='<body>';
	return $show;
}

function finish() {
	$show='</body></html>';
	return $show;
}

} ?>