<?php
//	svg contents
$saveDataLin = stripslashes($_POST["saveDataLin"]);
$saveDataAlp = stripslashes($_POST["saveDataAlp"]);
$saveDataCol = stripslashes($_POST["saveDataCol"]);
$saveDataALL = $saveDataCol . $saveDataAlp . $saveDataLin;
$saveData = preg_replace('#<+/?svg.*>#','',$saveDataALL);
$saveData = str_replace('enable-background="new    "','',$saveData);
$saveData = str_replace('opacity="0.75" fill="#1A1A1A"','fill="rgba(26,26,26,0.5)"',$saveData);
$saveData = str_replace('opacity="0.5" fill="#1A1A1A"','fill="rgba(26,26,26,0.25)"',$saveData);


$svgData = '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="600px" height="600px" viewBox="0 0 600 600" enable-background="new 0 0 600 600" xml:space="preserve">' . $saveData . '</svg>';

//	create temp files
$tmpName = md5(rand());
chmod("save/tmp/", 0777);
$tmpSvg = 'save/tmp/' . $tmpName . '.svg';
//$tmpSvg = 'save/circle.svg';
$tmpPng = 'save/tmp/' . $tmpName . '.png';
file_put_contents($tmpSvg,$svgData);


//	convert
$output = '/usr/local/bin/convert -background none ' . $tmpSvg . ' ' . $tmpPng;
system($output);

//	stream
header('Content-type: image/png');
header('Content-Disposition: attachment; filename="mongoose.png"');
echo file_get_contents($tmpPng);

//	delete
//unlink($tmpSvg);
unlink($tmpPng);


?>