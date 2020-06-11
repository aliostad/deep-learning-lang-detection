<?php
session_start();
if(isset($_SESSION['session_user'])&&isset($_SESSION['session_user_type'])&&isset($_SESSION['authenticated'])){

	if(isset($_POST['service_availed_searchfield'])&&isset($_POST['service_availed_search_cat'])){

		$service_availed_searchfield = trim($_POST['service_availed_searchfield']);
		$service_availed_search_cat = $_POST['service_availed_search_cat'];

		if($_SESSION['session_user_type'] == 'Husai Customer'){
			$user = $_SESSION['session_user'];
		}else if($_SESSION['session_user_type'] == 'Husai Administrator'){
			if(isset($_GET['id'])&&isset($_GET['name'])){
				$user = $_GET['id'];
			}
		}

		if($service_availed_search_cat=="Service"){
			if($service_availed_searchfield!=""){
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' and service.service_name like '%".$service_availed_searchfield."%' order by service.service_name";
			}else{
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' order by service.service_name";
			}
		}else if($service_availed_search_cat=="Therapist"){
			if($service_availed_searchfield!=""){
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' and availed_service.therapist like '%".$service_availed_searchfield."%' order by availed_service.therapist";
			}else{
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' order by availed_service.therapist";
			}
		}else if($service_availed_search_cat=="Date"){
			if($service_availed_searchfield!=""){
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' and availed_service.date_availed like '%".$service_availed_searchfield."%' order by availed_service.date_availed desc";
			}else{
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' order by availed_service.date_availed desc";
			}
		}else if($service_availed_search_cat=="Type"){
			if($service_availed_searchfield!=""){
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' and service.category like '%".$service_availed_searchfield."%' order by service.category";
			}else{
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' order by service.category";
			}
		}else if($service_availed_search_cat=="Remarks"){
			if($service_availed_searchfield!=""){
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' and availed_service.remarks like '%".$service_availed_searchfield."%' order by availed_service.remarks";
			}else{
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' order by availed_service.remarks";
			}
		}else{
			if($service_availed_searchfield!=""){
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' and (service.service_name like '%".$service_availed_searchfield."%' or availed_service.therapist like '%".$service_availed_searchfield."%' or availed_service.date_availed like '%".$service_availed_searchfield."%' or service.category like '%".$service_availed_searchfield."%') order by availed_service.date_availed desc";
			}else{
				$query = "SELECT availed_service.date_availed, availed_service.therapist, service.service_name, service.category, availed_service.remarks, availed_service.id from availed_service join service on service.id=availed_service.service_id where availed_service.username='".$user."' order by availed_service.date_availed desc";
			}
		}
	}

	if($_SESSION['session_user_type'] == 'Husai Customer'){
		include("../../application/views/services-availed/services-availed-all.php");
	}else if($_SESSION['session_user_type'] == 'Husai Administrator'){
		if(isset($_GET['id'])&&isset($_GET['name'])){
			include("../../application/views/services-availed/manage-services-availed.php");
		}else{
			header('Location: ../accounts/');
		}
	}
	exit;


}else{

	include("../actions/logout.php");
	exit;
}

?>