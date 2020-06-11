<?php

require_once 'AlphabetValidationHandler.php';
require_once 'MaxLengthValidationHandler.php';
require_once 'NotNullValidationHandler.php';

$not_null_handler = new NotNullValidationHandler();
$length_handler = new MaxLengthValidationHandler(10);
$alphabet_handler = new AlphabetValidationHandler();



$length_handler->setHandler($alphabet_handler);
$handler = $not_null_handler->setHandler($length_handler);
$input = $argv[1];

echo '######## ';

$result = $handler->validate($input);
if ($result === FALSE) {
  echo '検証できませんでした';
} else if (is_string($result) && $result !== '') {
  echo $result;
} else {
  echo 'OK';
}

echo ' ########';
?>
