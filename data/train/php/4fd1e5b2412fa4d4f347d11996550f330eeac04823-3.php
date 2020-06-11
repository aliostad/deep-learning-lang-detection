<?php
/*
 本コードは、意図的にShift_JISで記述しています
 */

header("Content-type: text/html charset=Shift_JIS");
?>
<meta charset="Shift_JIS">
<pre>
<?php
// magic_quotes_gpc の現在の設定
echo "magic_quotes_gpc is ...\n";
var_dump( get_magic_quotes_gpc() );

// 擬似的な、magic_quotesの挙動の確認
$s = "O'Reilly";
var_dump($s);
var_dump( addslashes($s) );

//
$s = 'test"test';
var_dump($s);
var_dump( addslashes($s) );

//
$s = 'test\\test';
var_dump($s);
var_dump( addslashes($s) );

//
$s = '成績表 ';
var_dump($s);
var_dump( addslashes($s) );

//
$s = addslashes($s);
var_dump($s);
var_dump( addslashes($s) );

//
$s = addslashes($s);
var_dump($s);
var_dump( addslashes($s) );
