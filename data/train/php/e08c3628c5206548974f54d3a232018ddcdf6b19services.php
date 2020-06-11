<?php
	//////////////////////////////////////////////////////////////////
	// LOAD RESOURCES
	//////////////////////////////////////////////////////////////////
	require_once('../../../config.php');
	

	//////////////////////////////////////////////////////////////////
	// CREATE SERVICE
	//////////////////////////////////////////////////////////////////
	if(empty($_POST['id']) && (!empty($_POST['name_fr']) || !empty($_POST['name_en'])))
	{
		$service = new Services();
		
		$service->service_name_fr = $_POST['name_fr'];
		$service->service_name_en = $_POST['name_en'];
		
		$service->created_by_id = 2;
		$service->modified_by_id = 2;
		
		$service->Create();
		
	}
	
	//////////////////////////////////////////////////////////////////
	// UPDATE SERVICE
	//////////////////////////////////////////////////////////////////
	if(!empty($_POST['id']))
	{
		$service = new Services();
	
		$service->service_id = $_POST['id'];
		$service->service_name_fr = $_POST['name_fr'];
		$service->service_name_en = $_POST['name_en'];
		
		$service->modified_by_id = 2;
		
		$service->Update();
	}
	
	//////////////////////////////////////////////////////////////////
	// DELETE SERVICE
	//////////////////////////////////////////////////////////////////
	if(!empty($_GET['delete']))
	{
		$service = new Services();
		
		$service->service_id = $_GET['delete'];
		
		$service->Delete();	
	}
 ?>