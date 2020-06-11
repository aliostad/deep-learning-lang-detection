<?php

include 'vendor/autoload.php';

$target = [
	"foo" => ["bar", "baz"],
	"" => 0,
	"a/b" => 1,
	"c%d" => 2,
	"e^f" => 3,
	"g|h" => 4,
	"i\\j" => 5,
	"k\"l" => 6,
	" " => 7,
	"m~n" => 8
];

$pointer = new \gamringer\JSONPointer\Pointer($target);

var_dump($pointer->get(addslashes("")));
var_dump($pointer->get(addslashes("/foo")));
var_dump($pointer->get(addslashes("/foo/0")));
var_dump($pointer->get(addslashes("/")));
var_dump($pointer->get(addslashes("/a~1b")));
var_dump($pointer->get(addslashes("/c%d")));
var_dump($pointer->get(addslashes("/e^f")));
var_dump($pointer->get(addslashes("/g|h")));
var_dump($pointer->get(addslashes("/i\\j")));
var_dump($pointer->get(addslashes("/k\"l")));
var_dump($pointer->get(addslashes("/ ")));
var_dump($pointer->get(addslashes("/m~0n")));
var_dump($pointer->get('#'));
var_dump($pointer->get('#/foo'));
var_dump($pointer->get('#/foo/0'));
var_dump($pointer->get('#/'));
var_dump($pointer->get('#/a~1b'));
var_dump($pointer->get('#/c%25d'));
var_dump($pointer->get('#/e%5Ef'));
var_dump($pointer->get('#/g%7Ch'));
var_dump($pointer->get('#/i%5Cj'));
var_dump($pointer->get('#/k%22l'));
var_dump($pointer->get('#/%20'));
var_dump($pointer->get('#/m~0n'));
