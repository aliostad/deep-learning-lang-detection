<?php

$string = "whatever dude, whatever";
$s2 = "hi";

var_dump(preg_match("/hatever/s", $string, $result));
var_dump($result);


var_dump(preg_match("/hatever/As", $string, $result));
var_dump($result);


var_dump(preg_match("/^hatever/s", $string, $result));
var_dump($result);

var_dump(preg_match("/^whatever/s", $string, $result));
var_dump($result);

var_dump(preg_match("/hatever/As", $string, $result, null, 1));
var_dump($result);


var_dump(preg_match("/$/As", $s2, $result, null, 2));
var_dump($result);


$fp = fopen('php://stdin', 'r');
fgets($fp, 2);