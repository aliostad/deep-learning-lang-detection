<?php
/**********  仅测试程序 **********/

$savePath = './';  //图片存储路径
$savePicName = time();  //图片存储名称


$file_src = $savePath.$savePicName."_src.jpg";
$filename162 = $savePath.$savePicName."_162.jpg"; 
$filename48 = $savePath.$savePicName."_48.jpg";     

$src=base64_decode($_POST['pic']);
$pic1=base64_decode($_POST['pic1']);   
$pic2=base64_decode($_POST['pic2']);    

if($src) {
	file_put_contents($file_src,$src);
}

file_put_contents($filename162,$pic1);
file_put_contents($filename48,$pic2);

$rs['status'] = 1;
$rs['picUrl'] = $savePath.$savePicName;

print json_encode($rs);

?>
