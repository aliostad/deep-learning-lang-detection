<?php
	session_start();

	if( ! isset( $_POST['idService'] ) || ! is_numeric( $_POST['idService'] ) ){

		$_SESSION['message']['text'] = "Impossible de supprimer le service " ;
		$_SESSION['message']['type'] = "error"; 

	}else{

		require_once("../../models/m_service.class.php");
		$m_service = new m_service();

		$idService = $_POST['idService'];
		$m_service->delete($idService) ;
		$_SESSION['message']['text'] = "Service supprimé " ;
		$_SESSION['message']['type'] = "valid"; 
		
	} 
	header('Location: ../services/deleteService.php');
?>