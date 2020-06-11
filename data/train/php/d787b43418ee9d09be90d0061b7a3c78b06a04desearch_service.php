<?php

	require_once("../common/database_connection.php");
	$service = $_POST['service'];
	if(!empty($service)){
	
		$service_search_query="select service.service_id, service.name from service_list as service where service.name like '%{$service}%' limit 5";
		
		$result=mysql_query($service_search_query,$connection);
		
		if(mysql_num_rows($result)>0){
			while($row=mysql_fetch_array($result)){
				echo "<li class=\"service_list\"><input type=\"hidden\" class=\"fetched_service_id\" value=\"{$row['service_id']}\" />{$row['name']}</li>";
			}
		}
		else{
			echo "<li>no service exists</li>";
		}
	
	}
	
	require_once("../common/close_connection.php");

?>