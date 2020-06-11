<?php 
//check keys
$api_key = isset($_REQUEST['api_key']) ? $_REQUEST['api_key'] : '';
$api_sig = isset($_REQUEST['api_sig']) ? $_REQUEST['api_sig'] : '';

//check values
if(empty($api_key))
	pb_api_error_message(400, "invalid parameters: api_key");

if(empty($api_sig))
	pb_api_error_message(400, "invalid parameters: api_sig");

//open db conn
data::open_conn();
//check api_sig
$project = project_manager::get_by_api_sig($api_key, $api_sig);
if(!isset($project))
	pb_api_error_message(404, "application not found");
?>