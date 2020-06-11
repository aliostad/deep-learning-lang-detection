<?php

define('URL','http://tart/');
define('JS_VERSION_STRING','0.1');

$vychozi_model = "index";

$povolene_akce = array(
			"index" => array("show"),
			"vyhody" => array("show"),
			"technologie" => array("show"),
			"produkty" => array("show"),
			"kontakty" => array("show")
		);

$menu = array(
	array(
		"name" => "Výhody fólie BUFO",
		"model" => "vyhody",
		"action" => "show"
	),
	array(
		"name" => "Technologie",
		"model" => "technologie",
		"action" => "show"	
	),
	array(
		"name" => "Produkty",
		"model" => "produkty",
		"action" => "show"
	),
	array(
		"name" => "Kontakty",
		"model" => "kontakty",
		"action" => "show"
	)
);
