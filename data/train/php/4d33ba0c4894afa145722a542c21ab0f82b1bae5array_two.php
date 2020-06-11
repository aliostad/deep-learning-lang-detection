<?php
	header("Content-Type: text/plain; Charset=utf-8");
	
	$array1 = array(
			1,
			2,
			3,
			4
			);
	
	var_dump($array1);
	echo "\n";
	var_dump(current($array1));
	echo "\n";
	var_dump(next($array1));
	echo "\n";
	var_dump(prev($array1));
	echo "\n";
	next($array1); next($array1);
	var_dump(current($array1));
	echo "\n";
	var_dump(reset($array1));
	echo "\n";
	var_dump(end($array1));
	var_dump(key($array1));
	echo "\n";
	var_dump(next($array1));
	var_dump(key($array1));
	var_dump(reset($array1));
	var_dump(prev($array1));
	var_dump(reset($array1));
	echo "\n";
	var_dump(count($array1));
	echo"\n";
	var_dump(each($array1));
	echo "\n";
	var_dump(current($array1));
	echo "\n";
	
	$array2 = array(
			array(
					"a",
					"b",
					"c"
					),
			array(
					"A",
					"B",
					"C"
					),
			array(
					1,
					2,
					3
					)
			);

	var_dump(current($array2));
	var_dump(next($array2));
	var_dump(next($array2[1]));
	echo "\n";
	list($jedna,,$tri) = $array1;
	var_dump($jedna);
	var_dump($tri);
	list(,,,$ctyri) = $array1;
	var_dump($ctyri);
	
	
	