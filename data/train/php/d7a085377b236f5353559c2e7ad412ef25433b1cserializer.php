<?php

function create_dump($key, $value)
{
	$data = serialize($value);
	$fp = fopen("$key.data", "w");
	fwrite($fp, $data);
	fclose($fp);

}
create_dump("null", null);
create_dump("one", 1);
create_dump("true", true);
create_dump("pi", pi());
create_dump("helloworld", "helloworld");

$a = array("answer" => "42");
create_dump("array1", $a); 

$a = array(true, false, 0, 1, 3.14, "hello world", array('one' => 1, 'two' => 2, 'three' => 3));
create_dump("array2", $a); 

$a = array(null, false, 0, "", "0", 0.0, array());
create_dump("empties", $a);

$a = array(true);
$a[] = &$a;
create_dump("arrayref", $a);

$a = array("1" => "xyz", "2" => "abc", "0" => "hello");
create_dump("assoc", $a);

$a = array("hello", "xyz", "abc");
create_dump("numeric", $a);

?>
