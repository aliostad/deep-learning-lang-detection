<?php

require_once("../facetly_api.php");
$facetly = new facetly_api;
$api_server = "http://sg2.facetly.com/1";
$api_path = "template/update";
$api_method = "POST";

// fill with template search value
$tplsearch = "";

// fill with template facet value
$tplfacet = "";

$api_key = "yiqoybfe";
$api_secret = "rzhizcpntx7c6cxv4nqocrx7mjemcaua";
$api_data = array(
  "tplsearch" => $tplsearch,
  "tplfacet" => $tplfacet,
);

$facetly->setConsumer($api_key, $api_secret); 
$facetly->setServer($api_server);
$api_output = $facetly->call($api_path, $api_data, $api_method);
$return = json_decode($api_output);

print_r($return);


