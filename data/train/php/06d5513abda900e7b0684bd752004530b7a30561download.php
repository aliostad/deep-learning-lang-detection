<?php

$saveName = stripslashes($_GET["name"]); 
$savePath = stripslashes($_GET["path"]); 

$savePath = "http://pinoesel.de/joomla/php/gpx/20130707.gpx"; 
$saveName = "20130707.gpx"; 


echo "savePath ".$savePath;
echo "\n";
echo "saveName ".$saveName;
echo "\n";


if (file_exists($savePath))
{

echo "File does exist";


header ("Content-Type: application/octet-stream"); 
header ("Content-Disposition: attachment; filename=$saveName"); 
header ("Content-Transfer-Encoding: binary"); 
readfile($savePath); 

}
else
{
echo "File does not exist\n";
}

?>