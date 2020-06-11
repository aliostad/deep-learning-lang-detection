<?php
$save=new saveData($_POST);
$p=$save->performAction($p);
//$sql="SELECT admintype_id as type FROM ".DB_SCHEMA.".user_admin WHERE user_id=".$p->parametri["user_admin"]; 
//$sql="DELETE FROM ".DB_SCHEMA.".project_admin WHERE NOT username IN (SELECT DISTINCT username FROM ".USER_SCHEMA.".users)";
//echo "<p>$sql</p>";
/*$save->db->sql_query($sql);
$row = $save->db->sql_fetchrow();
$adminType=$row[0];
if(!$adminType){
	$save->status=-1;
	$p->errors["generic"]="Impossibile determinare il ruolo dell'Utente.";
}
else{
	$save->parent_flds=Array("user"=>$save->parent_flds["user_admin"],"usergroup"=>$adminType);
//$save->parent_flds=Array("user"=>$save->parent_flds["user_admin"]);
	
}*/
?>