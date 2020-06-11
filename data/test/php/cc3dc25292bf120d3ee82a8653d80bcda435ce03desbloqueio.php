<?php

function desbloqueio($login, $codigo)
{

//$this->agi->verbose($login);
require_once('api_mkt.php');

$ip="186.208.4.2";
$Username="api"; 
$Pass="api123"; 
$Port=8728; 
 
    $API = new routeros_api();
    $API->debug = false;
    if ($API->connect($ip , $Username , $Pass, $Port)) {
       $API->write("/ppp/active/getall",false);
       $API->write('?name='.$login,true);      
       $READ = $API->read(false);
       $ARRAY = $API->parse_response($READ);
        if(count($ARRAY)>0){ 
             $API->write("/ppp/active/remove",false);    
             $API->write("=.id=".$ARRAY[0]['.id'],true);
             $READ = $API->read(false);
             $ARRAY = $API->parse_response($READ);
        }
       $API->disconnect();
    }




}

?>
