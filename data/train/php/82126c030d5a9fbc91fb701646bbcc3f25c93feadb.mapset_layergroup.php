<?php
$save=new saveData($_POST);
$p=$save->performAction($p);
if($save->status==1 && $save->action=="salva"){
	
	$mapset_name=$p->parametri["mapset"];
	$sql="DELETE FROM ".DB_SCHEMA.".mapset_qt WHERE mapset_name = '$mapset_name' AND NOT qt_id IN (SELECT DISTINCT qt_id FROM ".DB_SCHEMA.".qt INNER JOIN ".DB_SCHEMA.".layer USING(layer_id) WHERE layergroup_id IN (SELECT DISTINCT layergroup_id FROM ".DB_SCHEMA.".mapset_layergroup WHERE mapset_name='$mapset_name'));";
	if(!$save->db->sql_query($sql)) print_debug($sql,null,"save.manual");
}
?>