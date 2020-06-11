<?php 


$bool = false;
var_dump($bool);
var_dump(is_bool($bool));


$int2 = 0b101; // 二进制 5
$int10 = 1;
$int8 = 0123; // 八进制数 (等于十进制 83)
$int16 = 0x1A; // 十六进制数 (等于十进制 26)

var_dump($int2);
var_dump($int10);
var_dump($int8);
var_dump($int16);

var_dump(is_int($int2));

//var_dump(is_bool($int10));

echo '1 == true ? true:false <br>';
var_dump( 1 == true ? true:false);

echo '0b1 == true ? true:false <br>';
var_dump( 0b1 == true ? true : false);


$double = 4.31;
var_dump($double);


$string = "hello world";
var_dump($string);

class ShopProduct{

}

$object = new ShopProduct();
var_dump($object);


$array = array("a","b","c");
var_dump($array);


$resource = fopen("resource.txt", "a");
var_dump($resource);

$null = null;
var_dump($null);