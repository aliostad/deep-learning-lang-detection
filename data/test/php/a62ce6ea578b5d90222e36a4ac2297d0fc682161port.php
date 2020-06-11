<?php
include '../config.php';
//api_port
$a = "\"";
$uid = $_REQUEST["api_token"] ;
$uid1 = $a.$uid.$a;

class req{ 	
	public $api_result=1;
	public $api_result_msg='成功';
	public $api_data;	
}
//echo $uid1;
//echo "SELECT api_material,api_deck_port,api_ndock,api_ship,api_basic,api_log,api_p_bgm_id FROM userdata where uid = $uid1";
try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmt = $conn->prepare("SELECT api_material,api_deck_port,api_ndock,api_ship,api_basic,api_log,api_p_bgm_id FROM userdata where uid = $uid1");
    $stmt->execute();
    // 设置结果集为关联数组    
	$req = new req();	
	$result = $stmt->setFetchMode(PDO::FETCH_ASSOC);  
	$result = $stmt->fetchAll();
	$res = $result[0];
	$api_material =json_decode($res["api_material"]);
	$api_deck_port =json_decode($res["api_deck_port"]);
	$api_ndock =json_decode($res["api_ndock"]);
	$api_ship =json_decode($res["api_ship"]);	
	$api_basic =json_decode($res["api_basic"]);
	$api_log =json_decode($res["api_log"]);
	$api_p_bgm_id =json_decode($res["api_p_bgm_id"]);    
	$req->api_data->api_material= $api_material;	
	$req->api_data->api_deck_port= $api_deck_port;	
	$req->api_data->api_ndock =$api_ndock;	
	$req->api_data->api_ship =$api_ship;		
	$req->api_data->api_basic =$api_basic;	
	$req->api_data->api_log =$api_log;	
	$req->api_data->api_p_bgm_id =$api_p_bgm_id;		
	$req1 = json_encode($req);
	echo "svdata=$req1";		
	$dsn = null;
    }
catch(PDOException $e)
    {
    echo "Error: " . $e->getMessage();
    }
	
$conn = null;