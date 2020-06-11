<?php
// ショッピングカートの設定を取得
LoadModel("ShoppingSettings", "Shopping");

class Shopping_Customer_Show extends Clay_Plugin_Module{
	function execute($param){
		$copyKey = $param->get("copy", "copy");
		$copyFrom = $param->get("copy_from", "");
		$copyTo = $param->get("copy_to", "");
		$customerSessionKey = $params->get("session", "Shopping_Customer");
		$customerResultKey = $param->get("result", "customer");
		
		// 注文者と同じチェックボックス用配列
		$_SERVER["ATTRIBUTES"]["CHECBOX"][$copyKey]["1"] = "配送先は注文者と同じ";
		
		// セッションの顧客情報をパラメータに設定
		$_SERVER["ATTRIBUTES"][$customerResultKey] = $_SESSION[$customerSessionKey];
		if(!empty($_SERVER["ATTRIBUTES"][$customerResultKey][$copyKey])){
			foreach($_SERVER["ATTRIBUTES"][$customerResultKey] as $key => $value){
				if(preg_match("/^".$copyTo."(.+)$/", $name, $p) > 0){
					if(isset($_SERVER["ATTRIBUTES"][$customerResultKey][$copyFrom.$p[1]])){
						unset($_SERVER["ATTRIBUTES"][$customerResultKey][$name]);
					}
				}
			}
		}
	}
}
?>
