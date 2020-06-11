<?php
	header("Access-Control-Allow-Origin: *");
	$key = $_GET['key'];

	$mmc=memcache_init();
	if($mmc==false){
        echo "{\"status\":\"fail\",\"data\":\"mc init failed\"}";
    }else{
        $save = memcache_get($mmc,$key);
        if($save==""){
        	exit("{\"status\":\"fail\",\"data\":\"empty\"}");
        }
        memcache_delete($mmc,$key);
		$save = json_decode($save,true);
        echo "{\"status\":\"ok\",\"updatetime\":\"".$save['updatetime']."\",\"ip\":\"".$save['ip']."\",\"port\":\"".$save['port']."\",\"socketport\":\"".$save['socketport']."\"}";
    }
?>