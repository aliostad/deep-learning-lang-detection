<?php
//include_once("class.php");
class Save extends main{
	function save_id($save_id){return $save_id;}
	function adm_id($adm_id){return $adm_id;}
	function save_content($save_content){return $save_content;}
	function save_date($save_date){return $save_date;}
	function save_status($save_status){return $save_status;}

	function save_process($opt,$id=""){
		if($opt=="insert"){
			$save_id="";
			$adm_id=$this->adm_id;
			$save_content=$this->save_content;
			$save_date=$this->save_date;
			$save_status=$this->save_status;
			
			$table=SAVE;
			$this->returnQuery("insert into $table");
		}
	}
}
$obj_save=new Save();

?>