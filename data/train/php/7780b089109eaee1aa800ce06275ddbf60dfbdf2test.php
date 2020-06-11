<?php
require_once 'ExcelTool/LogSaveToExcel.php';

$logSaveToExcel = new LogSaveToExcel();
$filePath = "E:/tmp.log";
$data = $logSaveToExcel->readLog($filePath);
//$logSaveToExcel->saveToExcel($data);
$clolumnName = $logSaveToExcel->dataprocess($data);
print_r($clolumnName);
//echo count($clolumnName);
// for($row = 0 ; $row < count($data); $row++){
// 	for($column = 0; $column < count($data[$row]) ; $column++){
// 		echo $data[$row][$column].'  ';
// 	}
// 	echo "</br>";
	
// }

// for($i = 0 ; $i < count($clolumnName); $i++){
// 		echo $clolumnName[$i].'  ';
// }