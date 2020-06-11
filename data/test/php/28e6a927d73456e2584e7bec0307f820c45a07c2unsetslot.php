<?php
//库存装备
include '../config.php';
require "slotitem.php";
$a = "\"";
$uid = $_REQUEST["api_token"] ;
$uid1 = $a.$uid.$a;

class req{ 	
	public $api_result=1;
	public $api_result_msg='成功';
	public $api_data;	
}
try {
    $json0='{"api_slottype1":-1,"api_slottype2":-1,"api_slottype3":-1,"api_slottype4":-1,"api_slottype5":-1,"api_slottype6":-1,"api_slottype7":-1,"api_slottype8":-1,"api_slottype9":-1,"api_slottype10":-1,"api_slottype11":-1,"api_slottype12":-1,"api_slottype13":-1,"api_slottype14":-1,"api_slottype15":-1,"api_slottype16":-1,"api_slottype17":-1,"api_slottype18":-1,"api_slottype19":-1,"api_slottype20":-1,"api_slottype21":-1,"api_slottype22":-1,"api_slottype23":-1,"api_slottype24":-1,"api_slottype25":-1,"api_slottype26":-1,"api_slottype27":-1,"api_slottype28":-1,"api_slottype29":-1,"api_slottype30":-1,"api_slottype31":-1,"api_slottype32":-1,"api_slottype33":-1,"api_slottype34":-1,"api_slottype35":-1,"api_slottype36":-1,"api_slottype37":-1,"api_slottype38":-1,"api_slottype39":-1}';
	$unsetslot = json_decode($json0);
	$conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmt = $conn->prepare("SELECT slot_item FROM userdata where uid = $uid1");
    $stmt->execute();
    // 设置结果集为关联数组    
	$result = $stmt->setFetchMode(PDO::FETCH_ASSOC);  
	$result = $stmt->fetchAll(PDO::FETCH_COLUMN, 0); 	
	$obj = json_decode($result[0]);	
	for($i=0;$i<=count($obj)-1;$i++){
		if($obj[$i]->api_equipped==0){
			for($j=0;$j<=count($slotitem)-1;$j++){
				if($slotitem[$j]["api_id"]==$obj[$i]->api_slotitem_id){
					$type =json_decode($slotitem[$j]["api_type"])[2];					
                    $type = "api_slottype".$type;
					if(is_array($unsetslot->$type)){						
						$coun = count($unsetslot->$type);
						$data = $unsetslot->$type;
						$data[$coun]=$obj[$i]->api_id;
 						$unsetslot->$type = $data;
					}
					else{						
											
						$unsetslot->$type=array($obj[$i]->api_id);
					}
				}				
			}			
		}
	}    	
	$req = new req();
	$req->api_data=$unsetslot;
	$json=json_encode($req);
	echo "svdata=$json";
	$dsn = null;
    }
catch(PDOException $e)
    {
    echo "Error: " . $e->getMessage();
    }

?>