<?php
require_once("../facetly_api.php");
$facetly = new facetly_api;
$api_server = "http://sg2.facetly.net/1";
$api_path = "report/query";
$api_method = "POST";
$api_key = "y37fdeti";
$api_secret = "ebhqnbjrgwhqwgalhgymezpg3hq3aqsl";
$api_data = array(
  "fromdate"=> -30,
  "todate" => 0,
  "query" => 'acer',
);

$facetly->setConsumer($api_key, $api_secret); 
$facetly->setServer($api_server);
$api_output = $facetly->call($api_path, $api_data, $api_method);
$return = json_decode($api_output);

print_r($return);


