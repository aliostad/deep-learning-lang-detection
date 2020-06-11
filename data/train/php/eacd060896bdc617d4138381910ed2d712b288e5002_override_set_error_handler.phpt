--TEST--
Test set_error_handler overloading
--SKIPIF--
<?php if (!extension_loaded("aware")) print "skip"; ?>
--FILE--
<?php

function my_error_handler() {
}

function my_better_handler() {
}

function my_best_handler() {
}

set_error_handler('my_error_handler');
set_error_handler('my_better_handler');
$old = set_error_handler('my_best_handler');

restore_error_handler();
restore_error_handler();

$old = set_error_handler('my_better_handler');
var_dump($old);

restore_error_handler();
restore_error_handler();
restore_error_handler();
restore_error_handler();

?>
--EXPECT--
string(16) "my_error_handler"
