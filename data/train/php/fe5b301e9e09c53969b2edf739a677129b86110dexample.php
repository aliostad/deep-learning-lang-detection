<?php

require_once 'GoogleMovieShowtimes.php';

//Requests www.google.com/movies?near=washington
$test = new GoogleMovieShowtimes('washington');
ob_start(); 
var_dump($test->parse()); 
$save = ob_get_contents(); 
ob_end_clean();  
$save=array($save);
$k=(array)($save[0]);
print_r($k);
//$save=json_encode($save);
//$saveJSON=json_decode($save,true);
//$saveJSON=(array)($saveJSON);
function isJson($var) {
  return ((is_string($string) && (is_object(json_decode($string)) || is_array(json_decode($string))))) ? true : false;
}
//if(isJSON($saveJSON))
//{
//	echo "yes";
//}
//print_r($saveJSON[0]["theater"]);
//var_dump($saveJSON[0];
//echo $saveJSON[1];
//echo $saveJSON[2];
//echo $saveJSON[3];

?>
