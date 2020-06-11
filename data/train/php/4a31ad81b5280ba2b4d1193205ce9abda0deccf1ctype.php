<?php
$a = '0001111222';
var_dump($a);
var_dump(is_numeric($a)); //true
echo '<hr>';
var_dump(ctype_digit($a)); //true
echo '<hr>';
$a = '0.1';
var_dump($a);
var_dump(is_numeric($a)); //true
echo '<hr>';
var_dump(ctype_digit($a)); //false
echo '<hr>';
 
$a = '-1';
var_dump($a);
var_dump(is_numeric($a)); //true
echo '<hr>';
var_dump(ctype_digit($a)); //false
echo '<hr>';
 
$a = 'a';
var_dump($a);
var_dump(is_numeric($a)); //false
echo '<hr>';
var_dump(ctype_digit($a)); //false
echo '<hr>';
 
?>