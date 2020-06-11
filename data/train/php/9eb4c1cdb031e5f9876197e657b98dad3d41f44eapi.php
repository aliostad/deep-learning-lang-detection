<?php
	// JSON APi
	header("Content-Type: application/json;");
	header("Access-Control-Allow-Origin: *");
	require_once('brains/global.php');
	require_once('brains/class/api.php');

	$api = new Api;

	// Api settings
	switch ($_GET['stream']) {
		case 'dynamic':
			$query = "WHERE objavljeno = 1 AND time < ".time().' ORDER BY time DESC LIMIT 0, 4';

				$api->galleries 	= false;
				$api->order_show 	= true;
				$api->tags 			= true;
				$api->generate_api_content($query);
			break;
		
		case 'republic':
			$query = "WHERE objavljeno = 1 AND time < ".time().' ORDER BY time DESC LIMIT 4, 3';

				$api->gelleries		= false;
				$api->description 	= false;
				$api->content 		= false;
				$api->label 		= false;
				$api->main_image	= false;

				$api->generate_api_content($query);
			break;

		case 'left':
			$query = "WHERE objavljeno = 1 AND time < ".time().' ORDER BY time DESC LIMIT 0, 2';

				$api->galleries 	= false;
				$api->order_show 	= true;
				$api->generate_api_content($query);
			break;

		case 'podcast':
			$query = "WHERE objavljeno = 1 AND time < ".time().' ORDER BY time DESC LIMIT 0, 3';

				$api->galleries 	= false;
				$api->order_show 	= false;
				$api->generate_api_content($query);
			break;
	}


	
?>